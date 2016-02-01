%define		plugin	check_file_exists
Summary:	Monitoring plugin to check if a file exists or not
Name:		monitoring-plugin-%{plugin}
Version:	1.0
Release:	2
License:	GPL
Group:		Networking
Source0:	%{plugin}.sh
Source1:	%{plugin}.cfg
URL:		https://exchange.nagios.org/directory/Plugins/System-Metrics/File-System/check_file_exists/details
BuildRequires:	rpmbuild(macros) >= 1.654
Requires:	nagios-common
Requires:	nagios-plugins-libs
Conflicts:	nagios-nrpe < 2.15-5
BuildArch:	noarch
BuildRoot:	%{tmpdir}/%{name}-%{version}-root-%(id -u -n)

%define		_sysconfdir	/etc/nagios/plugins
%define		nrpeddir	/etc/nagios/nrpe.d
%define		plugindir	%{_prefix}/lib/nagios/plugins

%description
Monitoring plugin to check if a file exists or not.

%prep
%setup -qcT
cp -p %{SOURCE0} %{plugin}

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT{%{_sysconfdir},%{nrpeddir},%{plugindir}}
install -p %{plugin} $RPM_BUILD_ROOT%{plugindir}/%{plugin}
cp -p %{SOURCE1} $RPM_BUILD_ROOT%{_sysconfdir}/%{plugin}.cfg
touch $RPM_BUILD_ROOT%{nrpeddir}/%{plugin}.cfg

%clean
rm -rf $RPM_BUILD_ROOT

%triggerin -- nagios-nrpe
%nagios_nrpe -a %{plugin} -f %{_sysconfdir}/%{plugin}.cfg

%triggerun -- nagios-nrpe
%nagios_nrpe -d %{plugin} -f %{_sysconfdir}/%{plugin}.cfg

%files
%defattr(644,root,root,755)
%attr(640,root,nagios) %config(noreplace) %verify(not md5 mtime size) %{_sysconfdir}/%{plugin}.cfg
%attr(755,root,root) %{plugindir}/%{plugin}
%ghost %{nrpeddir}/%{plugin}.cfg
