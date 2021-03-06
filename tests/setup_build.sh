#!/bin/bash -xe

DOCKER_IMAGE=$1
SPECFILE=${TRAVIS_REPO_SLUG##*/}.spec
env

sudo docker run --rm=true \
		-v ${TRAVIS_BUILD_DIR}:/source:rw ${DOCKER_IMAGE} /bin/bash -c \
    "bash -xe /source/tests/run_build.sh ${SPECFILE}"
