#!/bin/bash -xe

# CentOS version.
OS_VERSION=$1
SPECFILE=$2
env

# TRAVIS_REPO_SLUG=<owner>/<repo>
if [ "$OS_VERSION" = "6.6" ]; then

  # sudo docker run --rm=true -v `pwd`:/repo:rw centos:centos${OS_VERSION} \
  sudo docker run --rm=true \
      -v ${TRAVIS_BUILD_DIR}:/source:rw \
      toopher/centos-i386:centos6 /bin/bash -c \
      "bash -xe /source/tests/run_build.sh ${OS_VERSION} ${SPECFILE}"

else

  echo "Unknown CentOS version ${OS_VERSION}"
  exit -1

fi
