
# Git Repository Revert Task

## Overview
This document provides instructions for reverting the latest commit in the Nautilus media application git repository on the Storage server in Stratos DC.

## Repository Details
- **Location**: `/usr/src/kodekloudrepos/media`
- **Server**: Storage server (Stratos DC)
- **Task**: Revert HEAD to previous commit (initial commit)

## Problem Statement
The Nautilus application development team reported an issue with recent commits pushed to the repository. The DevOps team needs to revert the repository HEAD to the last commit.

## Requirements
1. Revert the latest commit (HEAD) to the previous commit
2. The previous commit should have the message "initial commit"
3. Use "revert media" as the commit message for the new revert commit (all lowercase)

## Solution Overview
The task involves using `git revert` command to create a new commit that undoes the changes introduced by the latest commit. This approach is preferred over `git reset` as it:
- Preserves commit history
- Is safer for shared repositories
- Allows easy tracking of what was reverted and when

## Prerequisites
- SSH access to Storage server
- Appropriate permissions to access and modify the git repository
- Git installed on the server

## Expected Outcome
After completing the revert:
- A new commit with message "revert media" will be at HEAD
- The working directory state will match the "initial commit" state
- All commit history will be preserved
- The repository will be ready for the team to continue work

## Verification
After reverting, verify:
1. The new commit appears at HEAD with message "revert media"
2. The working directory matches the initial commit state
3. Git status shows a clean working tree
4. Git log shows all three commits (revert, original, and initial)

## Notes
- This is a safe operation that doesn't delete any history
- If changes need to be pushed to remote, use `git push origin <branch-name>`
- Team members may need to pull the latest changes after the revert

## Support
For questions or issues, contact the DevOps team.
