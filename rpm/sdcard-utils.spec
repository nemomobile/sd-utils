Name:       sd-utils
Summary:    SailfishOS scripts to mount/umount external sdcard.
Version:    0.4
Release:    1
Group:      System/Base
License:    MIT
BuildArch:  noarch
URL:        https://github.com/nemomobile/sd-utils/
Source0:    %{name}-%{version}.tar.gz
BuildRequires:  systemd
Requires:   systemd
# Required for lsblk
Requires:   util-linux

%description
%{summary}

%prep
%setup -q -n %{name}-%{version}

%build

%install
# mounting script
mkdir -p %{buildroot}%{_sbindir}
cp scripts/mount-sd.sh %{buildroot}%{_sbindir}
# systemd service install
mkdir -p %{buildroot}%{_unitdir}
cp scripts/mount-sd@.service %{buildroot}%{_unitdir}
# udev rules for mmcblk1*
mkdir -p %{buildroot}%{_udevrulesdir}
cp rules/90-mount-sd.rules %{buildroot}%{_udevrulesdir}

%files
%defattr(-,root,root,-)
%{_sbindir}/mount-sd.sh
%{_unitdir}/mount-sd@.service
%{_udevrulesdir}/90-mount-sd.rules
