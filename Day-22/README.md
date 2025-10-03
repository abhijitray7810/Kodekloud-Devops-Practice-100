
# Git Clone Task – Stratos DC Storage Server

## Objective
Place a copy of the DevOps team’s newly-created repository  
(`/opt/media.git`) into `/usr/src/kodekloudrepos` **as user natasha**  
without modifying any existing permissions or directories.

## Quick Start
```bash
ssh natasha@ststor01
cd /usr/src/kodekloudrepos
git clone /opt/media.git
