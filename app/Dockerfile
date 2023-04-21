FROM nextcloud:23.0.0-fpm-alpine

# Install required packages
RUN set -ex; \
    \
    apk add --no-cache \
    ffmpeg \
    imagemagick \
    supervisor \
    py3-numpy \
    py3-pillow \
    py3-asn1crypto;

SHELL ["/bin/sh", "-o", "pipefail", "-c"]

# Install optional packages
RUN set -ex; \
    \
    apk add --no-cache \
    py3-cffi \
    py3-scipy \
    py3-pynacl \
    py3-cryptography \
    py3-pip;

RUN set -ex; \
    \
    python3 -m pip install -U pip

RUN set -ex; \
    \
    python3 -m pip install pillow_heif

# Install pywavelets if it is not ARM
RUN set -ex; \
    \
    arch=$(arch | sed s/x86_64/amd64/) && \
    python3 -m pip install pywavelets
