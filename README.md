# docker-ruby-ffmpeg

This is the base for https://hub.docker.com/r/corprew/spackle-base/.

It adds ruby to https://hub.docker.com/r/corprew/ffmpeg-nonfree-docker/ (the `26.04` tag, Ubuntu 26.04 LTS).

Ruby is built from source (currently 4.0.7, with bundler and YJIT) because Ubuntu's packaged ruby lags behind. To bump it, update `RUBY_VERSION` and `RUBY_DOWNLOAD_SHA256` in the Dockerfile from https://www.ruby-lang.org/en/downloads/. Gems install into `/usr/local/bundle`. `build-essential` and `pkg-config` are kept so gems with native extensions can compile; gems that wrap system libraries still need those libraries' `-dev` packages (e.g. `libpq-dev` for `pg`).

It is useful as a base for images that use ruby to participate in media processing frameworks.

You could also do this by adding ffmpeg to the official ruby images from docker, but that's *alpine linux*, so if you have some unknown ubuntu dependency, you should use this instead.

