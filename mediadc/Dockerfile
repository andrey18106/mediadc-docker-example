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

# Install optional packages
RUN apk add --no-cache \
    py3-cffi \
    py3-scipy \
    py3-pynacl \
    py3-cryptography;
