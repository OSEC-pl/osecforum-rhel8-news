#!/bin/bash
# No more Dockerfile!
FEDORA_RELEASE=30
FEDORA_IMAGE=registry.fedoraproject.org/fedora-minimal:${FEDORA_RELEASE}

container=$(buildah from ${FEDORA_IMAGE})
DNF_TOOL=microdnf

buildah run $container -- $DNF_TOOL -y install make lha tar
buildah run $container -- $DNF_TOOL clean all

buildah add $container ${TOOLCHAIN_URL} /opt/

buildah run $container -- tar zxf /opt/${TOOLCHAIN_ARCHIVE} -C /opt/
buildah run $container -- rm /opt/${TOOLCHAIN_ARCHIVE}
buildah run $container -- ln -s /opt/sonnet-toolchain /opt/amiga-cross

buildah run $container -- mkdir /build
buildah config  --volume /build $container

buildah add $container entrypoint.sh /
buildah config --entrypoint /entrypoint.sh $container

buildah commit $container mycontainer:latest

