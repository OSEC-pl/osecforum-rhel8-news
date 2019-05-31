#!/bin/bash
# bc-as-a-service
# No more Dockerfile!
FEDORA_RELEASE=30
FEDORA_IMAGE=registry.fedoraproject.org/fedora-minimal:${FEDORA_RELEASE}

container=$(buildah from ${FEDORA_IMAGE})
DNF_TOOL=microdnf

buildah run $container -- $DNF_TOOL -y install nmap-ncat bc
buildah run $container -- $DNF_TOOL clean all

buildah run $container -- mkdir /logs
buildah config --volume /logs $container

buildah add $container entrypoint.sh /
buildah config --entrypoint /entrypoint.sh $container

buildah commit $container bcaas:latest

