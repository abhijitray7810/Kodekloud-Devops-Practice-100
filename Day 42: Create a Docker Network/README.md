# Docker Network Setup - Nautilus DevOps

## Overview

This document provides instructions for creating a custom Docker network on App Server 2 in Stratos DC for the Nautilus DevOps team.

## Objective

Create a Docker bridge network named `news` with specific subnet and IP range configurations to be used for future application deployments.

## Requirements

- Access to App Server 2 in Stratos DC
- Docker installed and running
- Appropriate sudo/root privileges

## Network Specifications

| Parameter | Value |
|-----------|-------|
| Network Name | `news` |
| Driver | `bridge` |
| Subnet | `192.168.0.0/24` |
| IP Range | `192.168.0.0/24` |
| Server | App Server 2 (Stratos DC) |

## Implementation Steps

### 1. Connect to App Server 2

```bash
ssh <username>@<app-server-2-hostname>
```

### 2. Create the Docker Network

Execute the following command to create the network with the required specifications:

```bash
docker network create news \
  --driver bridge \
  --subnet 192.168.0.0/24 \
  --ip-range 192.168.0.0/24
```

### 3. Verify the Network Creation

List all Docker networks to confirm the `news` network exists:

```bash
docker network ls
```

**Expected output should include:**
```
NETWORK ID     NAME      DRIVER    SCOPE
xxxxxxxxxx     news      bridge    local
```

### 4. Inspect Network Configuration

Verify the network configuration details:

```bash
docker network inspect news
```

**Expected JSON output should contain:**
```json
{
    "Name": "news",
    "Driver": "bridge",
    "IPAM": {
        "Config": [
            {
                "Subnet": "192.168.0.0/24",
                "IPRange": "192.168.0.0/24"
            }
        ]
    }
}
```

## Command Explanation

- **`docker network create news`**: Creates a new Docker network with the name "news"
- **`--driver bridge`**: Specifies the bridge network driver (provides isolated network for containers on a single host)
- **`--subnet 192.168.0.0/24`**: Defines the subnet range (256 IP addresses from 192.168.0.0 to 192.168.0.255)
- **`--ip-range 192.168.0.0/24`**: Specifies the range from which container IPs will be allocated

## Usage

Once created, containers can be connected to this network using:

```bash
docker run --network news <image-name>
```

Or for existing containers:

```bash
docker network connect news <container-name>
```

## Troubleshooting

### Network Already Exists

If you see an error that the network already exists:
```bash
docker network rm news
```
Then recreate it with the command above.

### Subnet Conflicts

If there's a subnet conflict with existing networks:
1. Check existing networks: `docker network ls`
2. Inspect conflicting networks: `docker network inspect <network-name>`
3. Choose a different subnet range or remove conflicting networks

### Permission Denied

If you encounter permission issues:
- Ensure you have appropriate privileges
- Try running with `sudo` if necessary
- Verify Docker daemon is running: `systemctl status docker`

## Validation Checklist

- [ ] Successfully SSH'd into App Server 2
- [ ] Docker network `news` created
- [ ] Network uses `bridge` driver
- [ ] Subnet configured as `192.168.0.0/24`
- [ ] IP range configured as `192.168.0.0/24`
- [ ] Network visible in `docker network ls` output
- [ ] Configuration verified with `docker network inspect news`

## Additional Resources

- [Docker Network Documentation](https://docs.docker.com/network/)
- [Docker Bridge Network Driver](https://docs.docker.com/network/bridge/)

## Notes

- This network is isolated to App Server 2 only
- The bridge driver provides network isolation between containers
- The /24 subnet provides up to 254 usable IP addresses for containers
- Network persists across Docker daemon restarts

---

**Created for:** Nautilus DevOps Team  
**Date:** October 21, 2025  
**Server:** App Server 2, Stratos DC
