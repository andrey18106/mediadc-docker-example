# self host rust desk relay
* [Back](../README.md)
* freedns wget to have a dynamic url for the remote desktop relay
* task manager daily script
* create new stack in portainer and copy `docker-compose.yml` file contents
* udp -tcp 21115-21119 port forward from router
  * run `ipconfig` on device
  * may need to open ports on firewall for device as well
* install rustdesk client and get key
* settings ip: url
  * key
  * login into docker terminal (portainer console login), `cat id_ed25519.pub` file
  * needs to be in key on all machines to connect, but should be encrypted and safe
* can remove ` -k _` in the docker compose file to not require the key