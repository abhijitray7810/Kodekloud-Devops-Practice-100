
# Day-21 | Storage-Server Bare Git Repo

Quick automation to bootstrap the central Git repository requested by the Nautilus development team.

## What it does
* Installs Git via `yum`
* Creates `/opt/blog.git` (bare repository)
* Sets correct ownership & safe-directory flags
* Prints a one-liner to clone the repo

## Usage
```bash
chmod +x command.sh
./command.sh
