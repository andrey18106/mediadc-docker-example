# Additional Services
* [Home](../README.md)

## RustDesk
* remote desktop open sourced relay hosting
* [see](./rustdesk/readme.md)

## Scrutiny
* monitor hard drive age
* [see](./scrutiny/readme.md)

## kuma
* monitoring downtime of websites
* `docker run -d --restart=always -p 3001:3001 -v uptime-kuma:/app/data --name uptime-kuma louislam/uptime-kuma:1` need running a different machine from the nextcloud can run multiple, works well on raspberry pi since lightweight.
