# docker-ruby-ffmpeg

This is the base for https://hub.docker.com/r/corprew/spackle-base/.

It adds ruby 2.3.x to https://hub.docker.com/r/corprew/ffmpeg-nonfree-docker/.

It is useful as a base for images that use ruby to participate in media processing frameworks.

You could also do this by adding ffmpeg to the official ruby images from docker, but that's *alpine linux*, so if you have some unknown ubuntu dependency, you have to do this instead.

