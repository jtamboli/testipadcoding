# Much of the contents copied from https://github.com/apple/swift-docker/blob/master/5.2/ubuntu/20.04/slim/Dockerfile
FROM gitpod/workspace-full
RUN sudo apt-get update -q && \
    sudo apt-get install -yq \
    #libtinfo5 \
    #libcurl4-openssl-dev \
    #libncurses5 && \
    #binutils \
    #git \
    #gnupg2 \
    #libc6-dev \
    libcurl4 \
    #libedit2 \
    #libgcc-9-dev \
    #libpython2.7 \
    #libsqlite3-0 \
    #libstdc++-9-dev \
    libxml2 \
    #libz3-dev \
    #pkg-config \
    tzdata \
    #zlib1g-dev \
    && sudo rm -rf /var/lib/apt/lists/*

ARG SWIFT_SIGNING_KEY=A62AE125BBBFBB96A6E042EC925CC1CCED3D1561
ARG SWIFT_PLATFORM=ubuntu20.04
ARG SWIFT_BRANCH=swift-5.2.4-release
ARG SWIFT_VERSION=swift-5.2.4-RELEASE
ARG SWIFT_WEBROOT=https://swift.org/builds/

ENV SWIFT_SIGNING_KEY=$SWIFT_SIGNING_KEY \
    SWIFT_PLATFORM=$SWIFT_PLATFORM \
    SWIFT_BRANCH=$SWIFT_BRANCH \
    SWIFT_VERSION=$SWIFT_VERSION \
    SWIFT_WEBROOT=$SWIFT_WEBROOT

RUN set -e; \
    SWIFT_WEBDIR="$SWIFT_WEBROOT/$SWIFT_BRANCH/$(echo $SWIFT_PLATFORM | tr -d .)/" \
    && SWIFT_BIN_URL="$SWIFT_WEBDIR/$SWIFT_VERSION/$SWIFT_VERSION-$SWIFT_PLATFORM.tar.gz" \
    && SWIFT_SIG_URL="$SWIFT_BIN_URL.sig" \
    # - Grab curl here so we cache better up above
    && export DEBIAN_FRONTEND=noninteractive \
    && sudo apt-get -q update && sudo apt-get -q install -y curl gnupg && sudo rm -rf /var/lib/apt/lists/* \
    # - Download the GPG keys, Swift toolchain, and toolchain signature, and verify.
    && export GNUPGHOME="$(mktemp -d)" \
    && curl -fsSL "$SWIFT_BIN_URL" -o swift.tar.gz "$SWIFT_SIG_URL" -o swift.tar.gz.sig \
    && gpg --batch --quiet --keyserver ha.pool.sks-keyservers.net --recv-keys "$SWIFT_SIGNING_KEY" \
    && gpg --batch --verify swift.tar.gz.sig swift.tar.gz \
    # - Unpack the toolchain, set libs permissions, and clean up.
    && sudo tar -xzf swift.tar.gz --directory / --strip-components=1 \
    && sudo chmod -R o+r /usr/lib/swift \
    && rm -rf "$GNUPGHOME" swift.tar.gz.sig swift.tar.gz \
    && sudo apt-get purge --auto-remove -y curl
