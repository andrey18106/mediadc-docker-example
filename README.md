# Nextcloud Docker configuration with Machine Learning Dependencies for plugins
* fork off of MediaDC docker compose
* currently targeting nextcloud 25 since this is the latest version supported by plugins
* plugins that will work with current setup
  * [MediaDC](#mediadc-docker-image-base-example)
  * recognize
  * facial recognize

## Getting Started
1. this is assumming you are using windows
1. setup new computer
1. create a local only account (not linked to email)
    1. grant local account admin access
    1. remove pin and do auto login (so on restart applications go back online)
1. install docker (wsl install)
1. config wsl memory for docker to persist after machine restart
1. install portainer (for managing apps)
1. buy a domain on [namecheap](https://namecheap.pxf.io/m5O5Ke) $15 a year and setup on cloudflare, setup cloudflare tunnel for public urls for your device and use subdomains for your services.
1. copy `example.env` to `.env`
    * `xcopy example.env .env`
    * update values as needed
1. update nginx values `web\nginx.conf` for your public url
1. replace nextcloud.example.com with your public url
1. `cd` into this folder
   * run docker compose `docker compose up -d`

## Hardware
* Note: raspberry pi is not powerful enough for nextcloud
* beelink-5500h (5500u is also fine, just less powerful)
* bump ram to 64 gb (not needed, but nice for handling more users)
* hdmi dummy plugin (for remote desktop)
* external hard drive (depends on your expected use, can replace later)
  * 16 TB 2x
  * 6 TB 2x
  * 8 TB ssd, 8 TB hd

## MediaDC docker image base example
There is a basic Docker Compose configuration example to use [MediaDC](https://github.com/andrey18106/mediadc) application.


## Advanced
You need to adjust your Nextcloud app container like in [/app/Dockerfile](/mediadc/Dockerfile)
to install required dependecies and re-build your container like in [docker-compose.yml](docker-compose.yml#L24).

* `docker compose up -d --build` will rebuild docker images

