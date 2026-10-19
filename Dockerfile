FROM corprew/ffmpeg-nonfree-docker:26.04

LABEL maintainer="Corprew Reed <github-public-incoming@corprew.org>"

# Ubuntu 26.04 only packages ruby 3.3, so build current stable ruby from source.
ENV RUBY_VERSION=4.0.7 \
    RUBY_DOWNLOAD_SHA256=911ace20f90d068ca0e4dda6d0e4f0f81e52e52f2dd4f4004c721e253412e82d \
    LANG=C.UTF-8

RUN set -eux; \
    # keep everything ffmpeg depends on when build deps are auto-removed below
    dpkg-query -W -f '${Package}\n' | xargs apt-mark manual > /dev/null; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates curl \
        libffi8 libgdbm6t64 libgmp10 libreadline8t64 libssl3t64 libyaml-0-2 zlib1g; \
    buildDeps=' \
        autoconf bison build-essential dpkg-dev libarchive-tools libffi-dev libgdbm-dev libgmp-dev \
        libreadline-dev libssl-dev libyaml-dev rustc zlib1g-dev \
    '; \
    apt-get install -y --no-install-recommends $buildDeps; \
    curl -fsSL -o ruby.tar.gz "https://cache.ruby-lang.org/pub/ruby/${RUBY_VERSION%.*}/ruby-${RUBY_VERSION}.tar.gz"; \
    echo "${RUBY_DOWNLOAD_SHA256} *ruby.tar.gz" | sha256sum --check --strict; \
    mkdir -p /usr/src/ruby; \
    # bsdtar rather than GNU tar, which fails under amd64 emulation on arm64 hosts
    bsdtar -xzf ruby.tar.gz -C /usr/src/ruby --strip-components=1; \
    rm ruby.tar.gz; \
    cd /usr/src/ruby; \
    ./configure \
        --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
        --disable-install-doc \
        --enable-shared \
        --enable-yjit; \
    make -j "$(nproc)"; \
    make install; \
    cd /; \
    rm -rf /usr/src/ruby; \
    apt-get purge -y --auto-remove $buildDeps; \
    rm -rf /var/lib/apt/lists/*; \
    ruby --version; \
    gem --version; \
    bundle --version

ENV GEM_HOME=/usr/local/bundle \
    BUNDLE_SILENCE_ROOT_WARNING=1
ENV BUNDLE_APP_CONFIG="$GEM_HOME" \
    PATH="$GEM_HOME/bin:$PATH"
RUN mkdir -p "$GEM_HOME" && chmod 1777 "$GEM_HOME"
