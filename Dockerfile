# Multi-stage image that builds sava-software/anchor-src-gen and exposes the generator

# ---------- Builder: compiles the generator and jlink image ----------
FROM gradle:jdk25-graal AS builder

RUN set -eux \
    && apt-get update \
    && apt-get install -y --no-install-recommends git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Use a RUN command with build secrets to create the gradle.properties file
RUN --mount=type=secret,id=github_username,target=/root/.gradle/github_username \
    --mount=type=secret,id=github_token,target=/root/.gradle/github_token \
    mkdir -p /root/.gradle \
    && printf "savaGithubPackagesUsername=%s\n" "$(cat /root/.gradle/github_username)" >> /root/.gradle/gradle.properties \
    && printf "savaGithubPackagesPassword=%s\n" "$(cat /root/.gradle/github_token)" >> /root/.gradle/gradle.properties

WORKDIR /opt
RUN git clone --depth 1 https://github.com/sava-software/anchor-src-gen.git
WORKDIR /opt/anchor-src-gen

# Build the custom Java runtime image used by the generator
RUN chmod +x gradlew compile.sh genSrc.sh \
    && ./compile.sh

# ---------- Runtime: minimal image with the generator runtime ----------
FROM debian:bookworm-slim AS runner

# genSrc.sh uses bash; screen is optional (disabled by default)
RUN set -eux \
    && apt-get update \
    && apt-get install -y --no-install-recommends bash ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create the directory structure expected by genSrc.sh
WORKDIR /opt/anchor-src-gen
RUN mkdir -p idl-src-gen/build/images

# Copy the built jlink image and helper script
COPY --from=builder /opt/anchor-src-gen/idl-src-gen/build/images/idl-src-gen idl-src-gen/build/images/idl-src-gen
COPY --from=builder /opt/anchor-src-gen/genSrc.sh ./genSrc.sh

RUN chmod +x ./genSrc.sh

# Default entrypoint runs the generator; pass flags via `docker run ... -- <flags>`
ENTRYPOINT ["./genSrc.sh"]
CMD ["--help"]
