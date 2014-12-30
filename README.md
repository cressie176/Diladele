# Dockerfile for Diladele Web Safety

A Diladele (previously known as qlproxy) content filtering proxy pre-configured for HTTPS and using dnsmasq to force google safe search

## Pre-requisits
1. [Docker](http://docker.io)
2. A [Diladele](http://diladele.com) license
3. A set of SSL Certificates [see here](http://docs.diladele.com/administrator_guide_4_0/system_configuration/https_filtering/generate_certificates.html)

## Quick Start
```bash
git clone https://github.com/cressie176/Diladele
cd Diladele
mkdir -p volumes/qlproxy/private volumes/qlproxy/backup
cp <YOUR DILADELE LICENSE KEY> volumes/qlproxy/private/license.key
cp <YOUR PEM CERTIFICATE> volumes/qlproxy/private/myca.pem
cp <YOUR DER CERTIFICATE> volumes/qlproxy/private/myca.der
docker run --name diladele --restart=always -d -p 80:80 -p 3128:3128 -v $(pwd)/volumes/qlproxy:/mnt/qlproxy -e TIME_ZONE='Europe/London' cressie176/diladele:4.0-beta
```

## Useful docker commands

```bash
# Build the docker image
docker build -t cressie176/diladele:4.0-beta .
```

```bash
# Start the diladele container interactively
docker run --name diladele -i -t -p 80:80 -p 3128:3128 -v $(pwd)/volumes/qlproxy:/mnt/qlproxy  -e TIME_ZONE='Europe/London' cressie176/diladele:4.0-beta

# Enter a running container
```bash
docker exec -i -t diladele /bin/bash
```

## Manually triggering a backup
```
docker exec -i -t diladele /etc/cron.hourly/qlproxy_backup
```

### TODO
1. logrotate
2. syslog
3. clamav
