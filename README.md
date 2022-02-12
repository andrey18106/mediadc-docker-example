# Nextcloud MediaDC Docker configuration

There is a basic Docker Compose configuration example to use [MediaDC](https://github.com/andrey18106/mediadc) application.

You need to adjust your Nextcloud app container like in [/mediadc/Dockerfile](/mediadc/Dockerfile)
to install required dependecies and build it in [docker-compose.yml](docker-compose.yml#L24)

## Installation with hands

If you don't want to use Dockerfile changes, you can install the required packages for the MediaDC app with hands, but to save changes they are needed to be committed into separate the Docker image.

### Connect to Nextcloud Docker container terminal

If you are using Docker GUI management (e.g. Portainer) - you can easily connect to the terminal via it (find container and the console button), otherwise, you can do it from your host server terminal:

1. `docker ps` - list active containers to find one with Nextcloud app and copy CONTAINER_ID.
2. `docker exec -it [CONTAINER_ID] [shell command]` - connect to the container's terminal.
`[shell command]` - path to shell executable, for Alpine it is `sh` (`/bin/sh/`), for other distros usually `bash` (`/bin/bash`).

Now, when you are logged in, you can install required packages to the container like in [/mediadc/Dockerfile](/mediadc/Dockerfile).

### Install required packages.

`apk add --no-cache ffmpeg imagemagick supervisor py3-numpy py3-pillow py3-asn1crypto`

### Install optional packages

`apk add --no-cache py3-cffi py3-scipy py3-pynacl py3-cryptography py3-pip`

### Upgrade pip

`pip install -U pip`

### Install [pillow_heif](https://github.com/bigcat88/pillow_heif)

`python3 -m pip install pillow_heif`

### Install pywavelets

`python3 -m pip install pywavelets`

After that check installation on the MediaDC Configuration page and it should be done.

### Save Docker container image changes

To save this changes you need to commit them to the separete Docker image. By default, the container being committed and its processes will be paused while the image is committed. This reduces the likelihood of encountering data corruption during the process of creating the commit. If this behavior is undesired, set the `--pause` option to false. Read more on [official docs](https://docs.docker.com/engine/reference/commandline/commit/).

`docker commit [CONTAINER_ID] [new_image_name]`
`docker image ls` - to check Docker `[new_image_name]` image created.

And use it instead of the previous default Nextcloud Docker image from Docker Hub. This is one of the disadvantages of this way of installation.
