# Stage I: Runtime =============================================================

# Step 1: Begin with Debian Buster:
FROM debian:buster AS runtime

ARG WATCHMAN_VERSION
ARG WATCHMAN_SHA256
ENV WATCHMAN_VERSION=${WATCHMAN_VERSION} \
    WATCHMAN_SHA256=${WATCHMAN_SHA256}

# Step 2: Install watchman runtime dependencies:
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    libssl1.1 \
 && rm -rf /var/lib/apt/lists/*

# Stage II: Builder ============================================================

# Step 3: Begin from runtime stage image:
FROM runtime AS builder

# Step 4: Install watchman build dependencies
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    build-essential \
    ca-certificates \
    curl \
    libssl-dev \
    libtool \
    openssl \
    pkg-config \
    python-dev \
 && rm -rf /var/lib/apt/lists/*

# Step 5: Download watchman source code:
RUN cd /tmp \
 && curl --silent --location --output watchman.tar.gz "https://github.com/facebook/watchman/archive/v${WATCHMAN_VERSION}.tar.gz" \
 && echo "$WATCHMAN_SHA256 *watchman.tar.gz" | sha256sum -c - \
 && tar -xz -f watchman.tar.gz -C /tmp/ \
 && rm -rf watchman.tar.gz

# Step 6: Build watchman from source:
RUN cd /tmp/watchman-${WATCHMAN_VERSION} \
 && ./autogen.sh \
 && ./configure --enable-lenient \
 && make \
 && make install \
 && cd $HOME \
 && rm -rf /tmp/*

# III: Release stage: ============================================================
# In this stage, we build the final, deployable Docker image, which will be
# smaller than the images generated on previous stages:

# Step 7: Begin with the runtime stage image:
FROM runtime AS release

# Step 8: Copy the compiled executable:
COPY --from=builder /usr/local/bin/watchman* /usr/local/bin/

# Step 9: Copy the documentation:
COPY --from=builder /usr/local/share/doc/watchman-4.9.0 /usr/local/share/doc/watchman-4.9.0

# Step 10: Copy the runtime directories:
COPY --from=builder /usr/local/var/run/watchman /usr/local/var/run/watchman
