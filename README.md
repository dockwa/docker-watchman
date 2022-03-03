# Facebook's Watchman for Docker Containers

[Watchman](https://facebook.github.io/watchman/) is a file watching service
developed by Facebook, and it's used by many projects (such as [Sorbet's
LSP](https://sorbet.org)) to watch files for changes, triggering project
rebuilds whenever a change is detected.

Instead of figuring out how to build watchman from source - or waiting for long
compilation times when building your Dockerfiles - you can use the "Multi-stage
Dockerfile" feature to copy the watchman executable directly from our image!

## Supported tags and respective Dockerfile links

> Remember that the image lives on GitHub Container Registry, not Docker Hub,
> so use `ghcr.io/dockwa/watchman:<TAG>`!

- [4.9.0-alpine-3.15](https://github.com/dockwa/docker-watchman/blob/master/alpine/3.15/Dockerfile)
- [4.9.0-debian-buster](https://github.com/dockwa/docker-watchman/blob/master/debian/buster/Dockerfile)

## Recommended usage on Alpine-based images:

```
# Start from whatever image you are using - this is a node app example:
FROM node:8-alpine

# Install the packages required for watchman to work properly:
RUN apk add --no-cache libcrypto1.0 libgcc libstdc++

# Copy the watchman executable binary directly from our image:
COPY --from=ghcr.io/dockwa/watchman:4.9.0-alpine-3.15 /usr/local/bin/watchman* /usr/local/bin/

# Create the watchman STATEDIR directory:
RUN mkdir -p /usr/local/var/run/watchman \
 && touch /usr/local/var/run/watchman/.not-empty

# (Optional) Copy the compiled watchman documentation:
COPY --from=ghcr.io/dockwa/watchman:4.9.0-alpine-3.15 /usr/local/share/doc/watchman* /usr/local/share/doc/

# Continue with the rest of your Dockerfile...
```

## Credits

Thanks to IcaliaLabs for [the original
implementation](https://github.com/IcaliaLabs/docker-watchman); this repo is
mostly a version bump and GHCR packaging layer with a slightly different
tagging scheme.
