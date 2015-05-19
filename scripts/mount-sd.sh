#!/bin/bash

# The only case where this script would fail is:
# mkfs.vfat /dev/mmcblk1 then repartitioning to create an empty ext2 partition

DEF_UID=$(grep "^UID_MIN" /etc/login.defs |  tr -s " " | cut -d " " -f2)
DEF_GID=$(grep "^GID_MIN" /etc/login.defs |  tr -s " " | cut -d " " -f2)
DEVICEUSER=$(getent passwd $DEF_UID | sed 's/:.*//')
MNT=/media/sdcard
MOUNT_OPTS="dirsync,noatime,users"
ACTION=$1
DEVNAME=$2

if [ -z "${ACTION}" ] || [ -z "${DEVNAME}" ]; then
    exit 1
fi

log () {
    systemd-cat -t mount-sd /bin/echo $@
}

log "Called to ${ACTION} ${DEVNAME}"

if [ "$ACTION" = "add" ]; then

    eval "$(/sbin/blkid -c /dev/null -o export /dev/$2)"

    if [ -z "${UUID}" ] || [ -z "${TYPE}" ]; then
        exit 1
    fi

    TARGET=$MNT/${UUID}

    DIR=$(grep -w ${DEVNAME} /proc/mounts | cut -d \  -f 2)
    if [ -n "$DIR" ]; then
        log "${DEVNAME} already mounted on ${DIR}, ignoring"
        exit 0
    fi

    # This hack is here to delay mounting the sdcard until tracker is ready
    export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$DEF_UID/dbus/user_bus_socket
    count=1
    while true; do 
        test $count -ge 64 && break
        MINER_STATUS="$(dbus-send --type=method_call --print-reply --session --dest=org.freedesktop.Tracker1.Miner.Files /org/freedesktop/Tracker1/Miner/Files org.freedesktop.Tracker1.Miner.GetStatus | grep -o 'Idle')"
        STORE_STATUS="$(dbus-send --type=method_call --print-reply --session --dest=org.freedesktop.Tracker1 /org/freedesktop/Tracker1/Status org.freedesktop.Tracker1.Status.GetStatus | grep -o 'Idle')"
        test "$MINER_STATUS" = "Idle" -a "$STORE_STATUS" = "Idle" && break
        log "Waiting $count seconds for tracker"
        sleep $count ; 
        count=$(( count + count ))
    done

    test -d ${TARGET} || mkdir -p ${TARGET}
    chown $DEF_UID:$DEF_GID $MNT ${TARGET}
    touch ${TARGET}

    case "${TYPE}" in
	vfat|exfat)
	    mount ${DEVNAME} ${TARGET} -o uid=$DEF_UID,gid=$DEF_GID,$MOUNT_OPTS,utf8,flush,discard || /bin/rmdir ${TARGET}
	    ;;
	# NTFS support has not been tested but it's being left to please the ego of an engineer!
	ntfs)
	    mount ${DEVNAME} ${TARGET} -o uid=$DEF_UID,gid=$DEF_GID,$MOUNT_OPTS,utf8 || /bin/rmdir ${TARGET}
	    ;;
	*)
	    mount ${DEVNAME} ${TARGET} -o $MOUNT_OPTS || /bin/rmdir ${TARGET}
	    ;;
    esac
    test -d ${TARGET} && touch ${TARGET}
    log "Finished ${ACTION}ing ${DEVNAME} of type ${TYPE} at ${TARGET}"

else
    DIR=$(grep -w ${DEVNAME} /proc/mounts | cut -d \  -f 2)
    if [ -n "${DIR}" ] ; then
        if [ "${DIR##$MNT}" = "${DIR}" ]; then
            log "${DEVNAME} mountpoint ${DIR} is not under ${MNT}, ignoring"
            exit 0
        fi
        umount $DIR || umount -l $DIR
        log "Finished ${ACTION}ing ${DEVNAME} at ${DIR}"
    fi
fi

