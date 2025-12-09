  # Git Post-Update Hook Setup for Ecommerce Repository

## Overview

This project sets up an automated release tagging system for the ecommerce git repository on the Storage server in Stratos DC. The solution implements a post-update hook that automatically creates release tags with the current date whenever changes are pushed to the master branch.

## Project Details

- **Repository Location**: `/opt/ecommerce.git` (cloned to `/usr/src/kodekloudrepos/ecommerce.git`) 
- **Server**: Storage server in Stratos DC
- **User**: natasha
- **Hook Type**: post-update (server-side hook)
- **Tag Format**: `release-YYYY-MM-DD` (e.g., `release-2025-10-13`)

## Objectives

1. Merge the `feature` branch into the `master` branch
2. Create a `post-update` hook that automatically generates release tags
3. Tag naming convention: `release-` followed by current date in YYYY-MM-DD format
4. Test the hook functionality
5. Push all changes to the remote repository

## Prerequisites

- SSH access to the Storage server
- User credentials for `natasha`
- Git installed on the server
- Proper permissions on the repository directory
- Repository already cloned from `/opt/ecommerce.git` to `/usr/src/kodekloudrepos/ecommerce.git`

## Features

### Automated Release Tagging
The post-update hook automatically creates a release tag whenever the master branch is updated. This ensures:
- Consistent tag naming convention
- Automatic version tracking
- Date-based release identification
- No manual intervention required for tagging

### Hook Functionality
- **Trigger**: Activated on push to master branch
- **Action**: Creates a git tag with format `release-YYYY-MM-DD`
- **Smart Check**: Prevents duplicate tags if one already exists for the current date
- **Automatic**: No manual tag creation needed

## Repository Structure

```
/usr/src/kodekloudrepos/ecommerce.git/
├── .git/
│   └── hooks/
│       └── post-update          # The hook script
├── [application files]
└── [other project files]
```

## Tag Format

Tags follow this naming pattern:
- **Format**: `release-YYYY-MM-DD`
- **Example**: `release-2025-10-13` (for October 13, 2025)
- **Usage**: Helps identify releases by date for easy tracking and rollback

## Usage

### Quick Start

1. SSH into the Storage server as `natasha`
2. Navigate to the repository directory
3. Run the setup script or follow manual steps
4. Verify the hook is working by checking for today's release tag

### Testing the Hook

After setup, test the hook by:
```bash
cd /usr/src/kodekloudrepos/ecommerce.git
git push origin master
git tag -l | grep release-
```

You should see a tag matching today's date.

## Files Included

- **README.md** (this file): Project overview and documentation
- **commands.md**: Quick reference of all commands used
- **steps.md**: Detailed step-by-step execution guide
- **setup_script.sh**: Automated setup script

## Important Notes

⚠️ **Permissions**: Ensure you maintain existing directory and file permissions. All operations should be performed as user `natasha`.

⚠️ **Bare Repository**: If `/opt/ecommerce.git` is a bare repository, the hook location should be `hooks/post-update` instead of `.git/hooks/post-update`.

⚠️ **Date Format**: The hook uses the system date. Ensure the server's date/time is correctly configured.

⚠️ **Duplicate Tags**: The hook checks for existing tags with the same name and will not create duplicates.

## Verification

After completing the setup, verify the following:

1. ✅ Feature branch merged into master
2. ✅ Post-update hook exists and is executable
3. ✅ Hook creates tags automatically on push
4. ✅ Release tag for current date exists
5. ✅ Changes pushed to remote repository

## Troubleshooting

### Hook Not Executing
- Check if the hook file is executable: `ls -l .git/hooks/post-update`
- Make it executable: `chmod +x .git/hooks/post-update`

### Tag Not Created
- Verify the hook script has no syntax errors
- Check git push output for error messages
- Manually test: `bash .git/hooks/post-update refs/heads/master`

### Permission Issues
- Ensure you're logged in as `natasha`: `whoami`
- Check directory permissions: `ls -ld /usr/src/kodekloudrepos/ecommerce.git`

### Remote Issues
- Verify remote URL: `git remote -v`
- Check connectivity to remote repository

## Support

For issues or questions:
1. Check the troubleshooting section
2. Review the steps.md file for detailed instructions
3. Verify all prerequisites are met
4. Check git and hook logs for error messages

## Author

DevOps Team - Stratos DC  
Nautilus Application Development

## Date

Created: October 2025  
Last Updated: October 13, 2025

## License

Internal use - Stratos Datacenter
