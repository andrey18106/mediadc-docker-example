# Nextcloud Docker configuration with Machine Learning Dependencies for plugins
* fork off of MediaDC docker compose
* currently targeting nextcloud 25 since this is the latest version supported by plugins
* container size is 2.7 gb. 
  * I didn't optimize it (using dockerfile steps to use create a smaller build)
  * This is because I'm not distributing the image, but the build steps
* nextcloud plugins that will work with current setup
  * [MediaDC](#mediadc-docker-image-base-example)
  * recognize
  * facial recognize

## Getting Started
1. this is assumming you are using windows
1. setup new computer
1. install software
   * vscode
   * git bash
1. create a local only account (not linked to email)
    1. grant local account admin access
    1. remove pin and do auto login (so on restart applications go back online)
1. On the new local admin account
    * install docker (wsl install)
    * set to auto start up
1. config wsl memory for docker to persist after machine 
    * `code %userprofile%\.wslconfig` and add these values to configure docker wsl limits
    ```js
    [wsl2]
    kernelCommandLine = "sysctl.vm.max_map_count=524288 sysctl.fs.file-max=131072"
    ```
1. install portainer (for managing apps)
   * `docker volume create portainer_data`
  * `docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest`
  * install watchtower to auto update docker images (not the custom built nextcloud ones) `docker run -d  --name watchtower --restart=always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower`
1. buy a domain on [namecheap](https://namecheap.pxf.io/m5O5Ke) $15 a year and setup on cloudflare, setup cloudflare tunnel for public urls for your device and use subdomains for your services.
1. setup your custom settings
  1. copy `example.env` to `.env`
      * `xcopy example.env .env`
      * update values as needed
  1. update nginx values `web\nginx.conf` for your public url
  1. replace nextcloud.example.com with your public url
  1. also check `TODO:`s and update values as needed in `docker-compose.yml` 
1. `cd` into this folder
   * run docker compose `docker compose up -d`
   * to rebuild images from scratch run `docker compose up -d --build`
1. log into portainer `https://localhost:9443/`
   * locate the nextcloud app container and console log in
      ![portainer console](doc_media/portainer_console.png)
   * run `./occ` get the user id needed, and log back in by user id
      ![portainer console](doc_media/portainer_console.png)


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
* You need to adjust your Nextcloud app container like in [/app/Dockerfile](/mediadc/Dockerfile)
to install required dependecies and re-build your container like in [docker-compose.yml](docker-compose.yml#L24).
* useful [additional services](./additional_services/README.md) to install
* database backup/restore (in git bash)
  * TODO: task scheduler to backup db to external drive daily and delete old backups
  * backup
    * docker exec -t your-db-container pg_dumpall -c -U postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql
  * restore `cat your_dump.sql | docker exec -i your-db-container psql -U postgres`

