Name:       sd-utils
Summary:    SailfishOS scripts to mount/umount external sdcard.
Version:    0.2
Release:    1
Group:      System/Base
License:    MIT
BuildArch:  noarch
URL:        https://github.com/nemomobile/sd-utils/
Source0:    %{name}-%{version}.tar.gz
BuildRequires:   oneshot
Requires(post):  oneshot

%description
%{summary}

%prep
%setup -q -n %{name}-%{version}

%build

%install
# mounting script
mkdir -p %{buildroot}%{_sbindir}
cp -r scripts/mount-sd.sh %{buildroot}%{_sbindir}
# udev rules for mmcblk1*
mkdir -p %{buildroot}%{_sysconfdir}/udev/rules.d
cp -r rules/90-mount-sd.rules %{buildroot}%{_sysconfdir}/udev/rules.d/
# oneshot run in install
mkdir -p mkdir -p %{buildroot}%{_oneshotdir}
cp -r scripts/tracker-sd-indexing.sh %{buildroot}%{_oneshotdir}


%post
add-oneshot --user --now tracker-sd-indexing.sh

%files
%defattr(-,root,root,-)
%{_sbindir}/mount-sd.sh
%{_sysconfdir}/udev/rules.d/90-mount-sd.rules
%{_oneshotdir}/tracker-sd-indexing.sh
