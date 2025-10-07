# Git Cherry-Pick Task - Nautilus Project

## Project Overview

This repository contains the solution for cherry-picking a specific commit from the `feature` branch to the `master` branch in the Nautilus blog application repository.

## Repository Details

- **Repository Location**: `/opt/blog.git`
- **Cloned Location**: `/usr/src/kodekloudrepos/blog.git`
- **Server**: Storage Server in Stratos DC
- **Branches**: `master` and `feature`

## Task Objective

Merge a specific commit with the message "Update info.txt" from the `feature` branch into the `master` branch without merging the entire feature branch.

## Solution Method

Used **git cherry-pick** to selectively apply a single commit from one branch to another.

## Key Concepts

### What is Cherry-Pick?

Git cherry-pick is a command that allows you to select specific commits from one branch and apply them to another branch. This is useful when:

- You want to apply only specific changes without merging entire branches
- A bug fix in a feature branch needs to be quickly applied to production
- You need to backport specific features

### Why Cherry-Pick?

In this scenario, the developer is still working on the `feature` branch, but needs one specific commit merged into `master` immediately. Cherry-picking allows this selective merge without bringing in all the work-in-progress changes.

## Results

- ✅ Commit "Update info.txt" successfully cherry-picked
- ✅ Changes pushed to remote master branch
- ✅ Feature branch remains unchanged with ongoing work

## Files in This Repository

- `README.md` - This file, project overview and documentation
- `steps.md` - Detailed step-by-step execution guide
- `commands.md` - Quick reference of all Git commands used
- `question.md` - Original task requirements and problem statement

## Team

- **Development Team**: Nautilus Application Development Team
- **DevOps Team**: Responsible for Git operations
- **Project**: Blog Application Repository

## Related Documentation

- [Git Cherry-Pick Documentation](https://git-scm.com/docs/git-cherry-pick)
- [Git Branching Strategies](https://git-scm.com/book/en/v2/Git-Branching-Branching-Workflows)

## License

Internal Nautilus Project - Stratos Datacenter

---

**Last Updated**: October 07, 2025  
**Status**: ✅ Completed Successfully
