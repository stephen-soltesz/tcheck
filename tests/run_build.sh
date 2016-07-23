#!/bin/bash -xe

OS_VERSION=$1
SPECFILE=$2

ls -l /home

# Check CentOS version
cat /etc/redhat-release

# Clean the yum cache
yum -y clean all
yum -y clean expire-cache

# First, install all the needed packages.
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-${OS_VERSION%%.*}.noarch.rpm
# Broken mirror?
echo "exclude=mirror.beyondhosting.net" >> /etc/yum/pluginconf.d/fastestmirror.conf

#yum -y update
yum -y clean all
yum -y install yum-plugin-priorities
yum -y install rpm-build gcc gcc-c++ cmake git tar gzip make autotools # boost-devel 

# Prepare the RPM environment
mkdir -p /tmp/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
cat /etc/rpm/macros.dist
cat >> /etc/rpm/macros.dist << EOF
%dist .mlab.el6
EOF

#cp /root/rpmbuild/RPMS/noarch/nodebase-0.1-0.noarch.rpm ${vdir}/root/
#chroot ${vdir} rpm -ihv /root/nodebase-0.1-0.noarch.rpm 

cp /repo/${SPECFILE} /tmp/rpmbuild/SPECS
package=$( rpm -q --specfile /repo/${SPECFILE} --queryformat '%{Name}\n' )
version=$( rpm -q --specfile /repo/${SPECFILE} --queryformat '%{Version}\n' )
# Repo directory must match the RPM spec file package name.
pushd /repo
  # CentOS 6 git version 1.7.1 does not support --format=tar.gz
  # Later versions of git do.
  git archive --format=tar --prefix=${package}-${version}/ HEAD | \
      gzip > /tmp/rpmbuild/SOURCES/${package}-${version}.tar.gz
popd

# Build the RPM
rpmbuild --define '_topdir /tmp/rpmbuild' -ba /tmp/rpmbuild/SPECS/${SPECFILE}

# After building the RPM, try to install it
yum localinstall -y /tmp/rpmbuild/RPMS/noarch/${package}*

# Run unit tests on installed package.
pushd /repo
  echo "TODO: ADD UNIT TESTS HERE."
popd

# Copy RPM to location mounted outside of container.
mkdir -p /repo/build
cp /tmp/rpmbuild/RPMS/noarch/${package}* /repo/build
