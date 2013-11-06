Name:       sd-utils
Summary:    SailfishOS scripts to mount/umount external sdcard.
Version:    0.1
Release:    1
Group:      System/Base
License:    MIT
BuildArch:  noarch
URL:        https://github.com/nemomobile/sd-utils/
Source0:    %{name}-%{version}.tar.bz2
BuildRequires:   oneshot
Requires(post):  oneshot

%description
%{summary}

%prep
%setup -q -n %{name}-%{version}

%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}%{_sbindir}
cp -r scripts/mount-sd.sh %{buildroot}%{_sbindir}
mkdir -p %{buildroot}%{_bindir}
cp -r scripts/tracker-sd-indexing.sh %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_sysconfdir}/udev/rules.d
cp -r rules/90-mount-sd.rules %{buildroot}%{_sysconfdir}/udev/rules.d/
mkdir -p %{buildroot}/usr/lib/systemd/user/pre-user-session.target.wants
cp -r systemd/tracker-sd* %{buildroot}/usr/lib/systemd/user/
ln -sf ../tracker-sd-indexing.path %{buildroot}/usr/lib/systemd/user/pre-user-session.target.wants/tracker-sd-indexing.path
#mkdir -p %{buildroot}/lib/systemd/system/graphical.target.wants
#cp -r systemd/mount-sd-onboot.service %{buildroot}/lib/systemd/system/
#ln -sf ../mount-sd-onboot.service %{buildroot}/lib/systemd/system/graphical.target.wants/mount-sd-onboot.service
mkdir -p mkdir -p %{buildroot}%{_oneshotdir}
cp -r scripts/setup-sd-indexing.sh %{buildroot}%{_oneshotdir}
 


%post
if [ "$1" -ge 1 ]; then
systemctl-user daemon-reload || :
systemctl-user restart tracker-sd-indexing.path || :
fi

add-oneshot --user --now setup-sd-indexing.sh

%files
%defattr(-,root,root,-)
%{_sbindir}/mount-sd.sh
%{_bindir}/tracker-sd-indexing.sh
%{_sysconfdir}/udev/rules.d/90-mount-sd.rules
%{_libdir}/systemd/user/*
%{_oneshotdir}/setup-sd-indexing.sh
#/lib/systemd/system/*


