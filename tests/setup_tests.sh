#!/bin/bash -xe

# CentOS version.
OS_VERSION=$1
SPECFILE=$2

if [ "$OS_VERSION" = "6" ]; then

  sudo docker run --rm=true -v `pwd`:/repo:rw centos:centos${OS_VERSION} \
      /bin/bash -c "bash -xe /repo/tests/run_build.sh ${OS_VERSION} ${SPECFILE}"

else

  echo "Unknown CentOS version ${OS_VERSION}"
  exit -1

fi
