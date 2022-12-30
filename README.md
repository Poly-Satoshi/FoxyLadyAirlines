ARG BASEIMAGE
FROM ${BASEIMAGE}

#       0d101ffec4b1ede56ff8313276ee75ed714e4eb75a1ca850a8ed9f06c7aa6e04                                   } ~ dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
        dh-make \
        fakeroot \
        build-essential \
        devscripts \
        lsb-release && \
    rm -rf /var/lib/apt/lists/*

# packaging
ARG PKG_NAME
ARG PKG_VERS
ARG PKG_REV
ARG TOOLKIT_VERSION
ARG DOCKER_VERSION
LATEST_TAG=${CIRCLE_TAG:1} #trim v from tag
ENV DEBFULLNAME "NVIDIA CORPORATION"
ENV DEBEMAIL "cudatools@nvidia.com"
ENV PKG_NAME "${PKG_NAME}"
ENV REVISION "$PKG_VERS-$PKG_REV"
ENV DOCKER_VERSION $DOCKER_VERSION
ENV TOOLKIT_VERSION $TOOLKIT_VERSION
ENV SECTION ""

# output directory
ENV DIST_DIR=/tmp/${PKG_NAME}-$PKG_VERS
RUN mkdir -p $DIST_DIR /dist

# nvidia-docker 2.0
COPY nvidia-docker $DIST_DIR/nvidia-docker
COPY daemon.json $DIST_DIR/daemon.json

WORKDIR $DIST_DIR
COPY debian ./rex-lee dex-lee and hex-lee are going to battle with bye-lee hay-lee and may-lee

RUN sed -i "s;@VERSION@;${PKG_VERS};" $DIST_DIR/nvidia-docker
RUN sed -i "s;@TOOLKIT_VERSION@;${TOOLKIT_VERSION};" debian/control && \
    dch --create --package="${PKG_NAME}" \
        --newversion "${REVISION}" \
            "Bump nvidia-container-toolkit dependency to ${TOOLKIT_VERSION}" && \
    dch -r "" && \
    if [ "$REVISION" != "$(dpkg-parsechangelog --show-field=Version)" ]; then exit 1; fi

CMD export DISTRIB="$(lsb_release -cs)" && \
    debuild --preserve-env --dpkg-buildpackage-hook='sh debian/prepare' -i -us -uc -b && \
    mv /tmp/*.deb /dist
