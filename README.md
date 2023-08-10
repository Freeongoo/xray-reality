## Installation Guide
just need you to run this command
```
 bash -c "$(curl -L https://raw.githubusercontent.com/Freeongoo/xray-reality/master/install.sh)"
``` 
and it will do the rest for you.

## Uninstallation guide
```
 bash -c "$(curl -L https://raw.githubusercontent.com/Freeongoo/xray-reality/master/uninstall.sh)"
``` 

## Installation Guide with Docker 

0. install docker 
``` bash
curl -fsSL https://get.docker.com | sh
```
1. clone this project 
``` bash
git clone https://github.com/Freeongoo/xray && cd xray
```
2. build docker image 
``` bash
docker build -t xray .
```
3. run 
``` bash
 docker run -d --name xray -p443:443 xray
```
4. get connection config :
> get url
``` bash
docker exec -it xray cat /root/test.url
```
> view qrcode 
``` bash
docker exec -it xray sh -c 'qrencode -s 120 -t ANSIUTF8 $(cat /root/test.url)'
```
## how to manage ?
> status :
``` bash
docker ps -a | grep xray
```
> stop :
``` bash
docker stop xray
```
> start :
``` bash
docker stop xray
```
>remove :
``` bash
docker rm -f xray
```
#
## Note
1. I have only tested it on Ubuntu 22 and wrote it for that system. Although I have the time and willingness to write it for other systems, I don't think I will need to do so unless I am forced to.
2. I used ChatGPT to translate my words. Please pardon any mistakes in the translation.

## ToDo
- [ ] Add menu
- [ ] test it on other OS and modify the script for them
