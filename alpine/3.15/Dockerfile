# Stage I: Runtime =============================================================

# Step 1: Begin with Alpine 3.15:
FROM alpine:3.15 AS runtime

ARG WATCHMAN_VERSION
ARG WATCHMAN_SHA256
ENV WATCHMAN_VERSION=${WATCHMAN_VERSION} \
    WATCHMAN_SHA256=${WATCHMAN_SHA256}

# Step 2: Install watchman runtime dependencies:
RUN apk add --no-cache libcrypto1.1 libgcc libstdc++

# Stage II: Builder ============================================================

# Step 3: Begin from runtime stage image:
FROM runtime AS builder

# Step 4: Install the watchman build dependencies:
RUN apk add --no-cache \
 autoconf \
 automake \
 bash \
 build-base \
 ca-certificates \
 libtool \
 linux-headers \
 openssl \
 openssl-dev \
 pkgconf \
 python3-dev

# Step 5: Download watchman source code:
RUN cd /tmp \
 && wget -O watchman.tar.gz "https://github.com/facebook/watchman/archive/v${WATCHMAN_VERSION}.tar.gz" \
 && echo "$WATCHMAN_SHA256 *watchman.tar.gz" | sha256sum -c - \
 && tar -xz -f watchman.tar.gz -C /tmp/ \
 && rm -rf watchman.tar.gz

# Step 6: Apply Build Patch
# (https://github.com/facebook/watchman/issues/937#issuecomment-904717182)
COPY ./watchman_autogen.sh.diff /tmp/
RUN cd /tmp/watchman-${WATCHMAN_VERSION} \
 && patch autogen.sh < /tmp/watchman_autogen.sh.diff

# Step 7: Build watchman from source:
RUN cd /tmp/watchman-${WATCHMAN_VERSION} \
 && ./autogen.sh \
 && ./configure --enable-lenient \
 && make \
 && make install \
 && cd $HOME \
 && rm -rf /tmp/*

# Stage III: Release ===========================================================

# Step 8: Begin with the runtime stage image:
FROM runtime AS release

# Step 9: Copy the compiled executable:
COPY --from=builder /usr/local/bin/watchman* /usr/local/bin/

# Step 10: Copy the documentation:
COPY --from=builder /usr/local/share/doc/watchman-4.9.0 /usr/local/share/doc/watchman-4.9.0

# Step 11: Copy the runtime directories:
COPY --from=builder /usr/local/var/run/watchman /usr/local/var/run/watchman
