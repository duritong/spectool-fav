Name:		spectool-fav
Version:	0.1
Release:	1%{?dist}
Summary:	Fetch and verify sources from an RPM specfile

License:	GPLv3
URL:		https://git.immerda.ch/%{name}
BuildArch: noarch
Source0:	https://git.immerda.ch/%{name}/plain/%{name}.rb

Requires:	ruby
Requires:	gnupg
Requires: rpmdevtools

BuildRoot:      %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)

%description

Automatically fetch all the sources of an RPM specfile and verify their checksum against a list of checksums.

%install
mkdir -p %{buildroot}/%{_bindir}
cp %{_sourcedir}/%{name}.rb %{buildroot}/%{_bindir}/%{name}

%files
%attr(755, root, root) %{_bindir}/spectool-fav

%changelog

* Sat Sept 13 2014 mh <mh+rpms@immerda.ch> - 0.1-1
Initial release
