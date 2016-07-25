%global release_date %(date -d @`git log -1 --format=%ct` +%Y%m%dT%H%M)

Summary: Dummy package for proof of concept
Name: tcheck
Version: 0.1
Release: %{release_date}
Group: System Environment/Base
License: Apache 2.0
BuildArch: noarch

%description
This is a stub package to demonstrate proof of concept for building RPMs in a
docker container.

# No files.
%files
