# Dockerfile for Diladele Web Safety

A Diladele (previously known as qlproxy) content filtering proxy with support for HTTPS

## Pre-requisits
1. [Docker](http://docker.io)
2. A [Diladele](http://diladele.com) license
3. A set of SSL Certificates [see here](http://docs.diladele.com/administrator_guide_4_0/system_configuration/https_filtering/generate_certificates.html)

## Running
```bash
mkdir -p volumes/qlproxy/private volumes/qlproxy/backup
cp <YOUR DILADELE LICENSE KEY> volumes/qlproxy/private/license.key
cp <YOUR PEM CERTIFICATE> volumes/qlproxy/private/myca.pem
cp <YOUR DER CERTIFICATE> volumes/qlproxy/private/myca.der
docker run --name diladele --restart=always -d -p 80:80 -p 3128:3128 -v $(pwd)/volumes/qlproxy:/mnt/qlproxy -e TIME_ZONE='Europe/London' cressie176/diladele:4.0-beta
```

## Building
```bash
# Build the docker image
docker build -t cressie176/diladele:4.0-beta .
```
## Other useful commands
### Enter a running container
```bash
docker exec -i -t diladele /bin/bash
```
### Start the diladele container interactively
```bash
docker run --name diladele -i -t -p 80:80 -p 3128:3128 -v $(pwd)/volumes/qlproxy:/mnt/qlproxy  -e TIME_ZONE='Europe/London' cressie176/diladele:4.0-beta
```
### Manually triggering a backup
```base
docker exec -i -t diladele /etc/cron.hourly/qlproxy_backup
```

### TODO
1. logrotate
2. syslog
3. clamav
