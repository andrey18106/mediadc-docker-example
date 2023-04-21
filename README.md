# Nextcloud Docker configuration with Machine Learning Dependencies for plugins
* fork off of [MediaDC docker compose](https://github.com/andrey18106/mediadc-docker-example)
* jump to [getting started](#getting-started)
* nextcloud features: 
  * great opensourced php based service for backing up personal photos and videos
  * has mobile and desktop apps
  * you can setup upload limits for users
  * reason why many choose it is b/c it's multi user and has facial recognition plugins per user
    * there are alternatives that have faster/better file syncing using deltas, but don't have facial recognition, there are some facial recognition docker images you can point to a folder, but you don't have multi user in these cases for now. 
  * despite all this do not forget to run backups (of your database and files)
    * database is less important b/c you can regenerate it
* currently targeting nextcloud 25 since this is the latest version supported by plugins
* container size is 2.7 gb. 
  * I didn't optimize it (using dockerfile steps to use create a smaller build)
  * This is because I'm not distributing the image, but the build steps
* nextcloud machine learning plugins that will work with current setup, as admin users `+apps` install the app there
  * remember to check downloads for app when deciding on which nextcloud version to upgrade to
  * [MediaDC](#mediadc-docker-image-base-example)
  * [Recognize](https://apps.nextcloud.com/apps/recognize)
   * recommended to set less cores to drive cpu usage to less than 100%
   * also node path needs to be set `/usr/local/nvm/versions/node/v16.13.0/bin/node` it'll depend on if you changed the version used
   * ![](doc_media/recognize_settings.PNG)
  * [Face Recognition](https://apps.nextcloud.com/apps/facerecognition)
   * need to console log into nextcloud app and download a module using the command line
* additional plugins that I've setup for convenience
  * [Registration](https://apps.nextcloud.com/apps/registration)
    * ![](doc_media/registration_plugin_setup.PNG)
  * [Social Login](https://apps.nextcloud.com/apps/sociallogin)
    * ![](doc_media/social_plugin_settings.PNG)
* plugin notes
  * in this config I do not have calendar and video calls enabled, you can enable these, I'm mostly focused on personal photo and video backups

## Getting Started
1. this is assumming you are using windows see [hardware](#hardware)
1. setup new computer
   * i just named the computer w/e the hardware is `beelink-5800h`, you can then ping it and use shared folders on the network on `beelink-5800h.local`
1. install software
   * vscode
   * git bash
   * remote desktop
     * teamviewer
     * rustdesk (free, but better to self host your own relay)
     * installed both
     * alternatives
       * anydesk, ...
   * resilio if syncing peer to peer folder contents to another folder (a form of backup)
1. create a local only account (not linked to email)
    1. grant local account admin access
    1. remove pin and do auto login (so on restart applications go back online)
      * regedit - `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\PasswordLess\Device`
      * change **DevicePasswordLessBuildVersion** value to 0
1. On the new local admin account
    * install docker (wsl install)
    * set to auto start up
1. config wsl memory for docker to persist after machine 
    * `code %userprofile%\.wslconfig` (create/open file in vscode) and add these values to configure docker wsl limits
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
      ![portainer_container_user_login](doc_media/portainer_container_user_login.png)
   * fix permisssions folder permissions
   ```bash
    chown -R www-data:www-data config
    chown -R www-data:www-data apps
    chown -R www-data:www-data custom_apps
    chown -R www-data:www-data data
   ```
1. as always test RESTARTING the computer after setup and see if services come back online, if they don't something isn't set up right.

## Hardware
* Note: raspberry pi is not powerful enough for nextcloud
* [beelink-5800H](https://amzn.to/3KYGctn) (5500U is also fine, just less powerful)
  * has windows 11 pro, can replace with linux such as ubuntu
* bump ram to [64 gb](https://amzn.to/3L0mkpS) (not needed, but nice for handling more users)
  * replacement video https://youtu.be/_iHyF2lAxYo
* [hdmi dummy plugs](https://amzn.to/3MZ6oXv) (for remote desktop)
* external hard drive storage options (depends on your expected use, can replace later)
  * [16 TB](https://amzn.to/43VdIti) 2x
  * [6 TB](https://amzn.to/3GZOvEb) 2x
  * [8 TB ssd](https://amzn.to/43QG7AC), [8 TB hd](https://amzn.to/3oBfrn8)

## MediaDC docker image base example
There is a basic Docker Compose configuration example to use [MediaDC](https://github.com/andrey18106/mediadc) application.

## Advanced
* You need to adjust your Nextcloud app container like in [app/Dockerfile](/mediadc/Dockerfile)
to install required dependencies and re-build your container like in [docker-compose.yml](docker-compose.yml#L24).
* after first docker compose launch some settings, have to be changed in the config.php file.
  * locate `\nextcloud-docker-ml-example_nextcloud` volume should be somewhere in `\\wsl.localhost\docker-desktop-data\data\docker\volumes`
  * `_data\config\config.php`
  * recommend backing up this file on the external drive
* useful [additional services](./additional_services/README.md) to install
* database backup/restore (in git bash)
  * TODO: task scheduler to backup db to external drive daily and delete old backups
  * backup
    *     docker exec -t your-db-container pg_dumpall -c -U postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql
  * restore `cat your_dump.sql | docker exec -i your-db-container psql -U postgres`
* TODO: sofware (maybe docker image) to sync nextcloud db backups and data to 2nd drive

