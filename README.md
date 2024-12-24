# admin-tools



## Install script (install.sh)
This script will install some tools and  setup a basic environment.
I wanted to automate the process of setting up a new server.

### Usage

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/greenst4r5/admin-tools/main/install.sh)"
```

## docker script (server/docker.sh)

This script will install docker and docker-compose on the server.

### Usage

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/greenst4r5/admin-tools/main/server/docker.sh)"
```

## netdata script (server/network.sh)

This will create a VPN connection has a service on the server.

### Usage

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/greenst4r5/admin-tools/main/server/network.sh)"
```