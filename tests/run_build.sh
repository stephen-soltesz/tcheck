#!/bin/bash -xe

SPECFILE=$1

ls -l /home

# Check CentOS version
cat /etc/redhat-release

# Clean the yum cache
yum -y clean all
yum -y clean expire-cache

# First, install all the needed packages.
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm

# TODO: enable update.
# yum -y update
yum -y clean all
yum -y install yum-plugin-priorities
yum -y install rpm-build gcc gcc-c++ cmake git tar gzip make autotools # boost-devel 

# Prepare the RPM environment
mkdir -p /tmp/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
cat /etc/rpm/macros.dist

export GIT_DIR=/source/.git
cp /source/${SPECFILE} /tmp/rpmbuild/SPECS
package=$( rpm -q --specfile /source/${SPECFILE} --queryformat '%{Name}\n' )
version=$( rpm -q --specfile /source/${SPECFILE} --queryformat '%{Version}\n' )

pushd /source
  # CentOS 6 git version 1.7.1 does not support --format=tar.gz
  # Later versions of git do.
  git archive --format=tar --prefix=${package}-${version}/ HEAD | \
      gzip > /tmp/rpmbuild/SOURCES/${package}-${version}.tar.gz
popd

# Build the RPM.
rpmbuild --define '_topdir /tmp/rpmbuild' -ba /tmp/rpmbuild/SPECS/${SPECFILE}

# After building the RPM, try to install it
yum localinstall -y /tmp/rpmbuild/RPMS/noarch/${package}*

# Run unit tests on installed package.
pushd /source
  echo "TODO: ADD POST-INSTALL TESTS HERE."
popd

# Copy RPM to location shared with external container.
mkdir -p /source/build
cp /tmp/rpmbuild/RPMS/noarch/${package}* /source/build
