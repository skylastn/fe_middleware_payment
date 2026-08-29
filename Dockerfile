FROM ubuntu:24.04 AS builder

ARG FLUTTER_VERSION=3.29.0

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/opt/flutter/bin:${PATH}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    unzip \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter from Google CDN
RUN curl -fsSL --retry 5 --retry-delay 5 --retry-all-errors \
    "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
    | tar -xJ -C /opt \
    && git config --global --add safe.directory /opt/flutter

WORKDIR /app

RUN flutter config --no-analytics \
    && flutter config --enable-web \
    && flutter precache --web

# Cache dependency layer first.
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy app source after dependency restore.
COPY . .

ARG BUILD_ENV_FILE=.env.production
ARG APP_VERSION=1.0.0
ARG APP_BUILDNUMBER=1

# Copy the chosen env file so --dart-define-from-file can read it.
RUN if [ -f "$BUILD_ENV_FILE" ]; then cp "$BUILD_ENV_FILE" .env; fi

# Build release web
RUN flutter build web --release --build-name=$APP_VERSION --build-number=$APP_BUILDNUMBER --dart-define-from-file=.env

# Small final image that stores build artifacts.
FROM alpine:3.21

WORKDIR /output

COPY --from=builder /app/build/web ./deploy

CMD ["sh", "-c", "cp -r /output/deploy/* /tmp/web-build/ && echo 'Web build copied to /tmp/web-build'"]
