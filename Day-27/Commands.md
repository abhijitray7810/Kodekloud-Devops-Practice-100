# Git Revert Commands - Quick Execution Guide

## Complete Command Sequence


# Step 1: Navigate to repository
```bash
cd /usr/src/kodekloudrepos/media
```
# Step 2: Check current commits
```bash
git log --oneline
```
# Step 3: Revert HEAD commit
```bash
git revert HEAD
```
# Step 4: In the editor that opens, replace the message with:
# revert media
# Then save and exit (:wq in vim, Ctrl+X then Y in nano)

# Step 5: Verify the revert
```bash
git log --oneline
git status
```

## Alternative: Non-Interactive Method

```bash
cd /usr/src/kodekloudrepos/media
git log --oneline
git revert HEAD --no-edit
git commit --amend -m "revert media"
git log --oneline
```

## Detailed Step-by-Step Commands

### 1. Navigate to Repository
```bash
cd /usr/src/kodekloudrepos/media
pwd  # Confirm you're in the right directory
```

### 2. Inspect Current State
```bash
# View all commits
git log

# View compact commit history
git log --oneline

# Check current status
git status

# View last 3 commits
git log -3 --oneline
```

Expected output should show:
- Current HEAD commit
- Previous commit with "initial commit" message

### 3. Revert the Latest Commit

**Method 1: Interactive (Recommended)**
```bash
git revert HEAD
```
This opens an editor. Replace the default message with:
```
revert media
```
Save and exit:
- **Vim**: Press `ESC`, type `:wq`, press `ENTER`
- **Nano**: Press `CTRL+X`, then `Y`, then `ENTER`
- **Vi**: Press `ESC`, type `:wq`, press `ENTER`

**Method 2: Two-Step Non-Interactive**
```bash
# Step 1: Revert without editing
git revert HEAD --no-edit

# Step 2: Change the commit message
git commit --amend -m "revert media"
```

**Method 3: Force Message (Git 2.23+)**
```bash
GIT_EDITOR='echo "revert media" >' git revert HEAD
```

### 4. Verify the Changes

```bash
# Check latest commit message
git log -1

# View commit history (should show 3 commits)
git log --oneline

# Expected output:
# abc1234 revert media           <- New revert commit (HEAD)
# def5678 <previous commit>      <- Commit being reverted
# ghi9012 initial commit         <- Original commit

# Check repository status
git status
# Should show: "nothing to commit, working tree clean"

# View details of the revert commit
git show HEAD
```

### 5. Additional Verification Commands

```bash
# Compare HEAD with the commit before the reverted one
git diff HEAD~2 HEAD
# Should show no differences (state matches initial commit)

# View commit graph
git log --graph --oneline --all --decorate

# Show which files changed in the revert
git show HEAD --stat

# Verify working directory is clean
git diff
# Should show no output
```

## Push to Remote (If Required)

```bash
# Check current branch
git branch

# Check remote repository
git remote -v

# Push changes to remote
git push origin <branch-name>

# Common branch names:
git push origin main
# OR
git push origin master
```

## Troubleshooting Commands

### Abort Revert (if something goes wrong)
```bash
git revert --abort
git status
```

### Check if Revert is in Progress
```bash
git status
# Will show: "You are currently reverting commit..."
```

### View What Changed in Revert
```bash
# Show files modified by the revert
git diff HEAD~1 HEAD --name-only

# Show detailed changes
git diff HEAD~1 HEAD
```

### Undo the Revert (if needed)
```bash
# Revert the revert (brings back the changes)
git revert HEAD
```

## Complete Copy-Paste Workflow

```bash
# === QUICK EXECUTION ===
cd /usr/src/kodekloudrepos/media && \
git log --oneline && \
git revert HEAD --no-edit && \
git commit --amend -m "revert media" && \
git log --oneline && \
echo "✓ Revert completed successfully"
```

## Verification Checklist

After running the commands, verify:

- [ ] New commit exists with message "revert media"
- [ ] Commit history shows 3 commits (revert, original, initial)
- [ ] Working directory is clean (`git status` shows no changes)
- [ ] HEAD points to the revert commit
- [ ] Repository state matches "initial commit" state

## Quick Reference Table

| Command | Purpose |
|---------|---------|
| `git revert HEAD` | Revert the latest commit |
| `git revert --abort` | Cancel ongoing revert |
| `git log --oneline` | View compact commit history |
| `git show HEAD` | View latest commit details |
| `git status` | Check repository status |
| `git commit --amend -m "msg"` | Change last commit message |

## Common Issues and Solutions

**Issue**: Editor doesn't open
```bash
# Set default editor
export GIT_EDITOR=nano
# OR
export GIT_EDITOR=vim
# Then retry: git revert HEAD
```

**Issue**: Merge conflicts during revert
```bash
# View conflicted files
git status

# Resolve conflicts manually, then:
git add .
git revert --continue
```

**Issue**: Wrong commit message
```bash
# Fix the message
git commit --amend -m "revert media"
```

## Notes

- ✓ `git revert` creates a NEW commit (safe for shared repos)
- ✓ Preserves all commit history
- ✓ Can be pushed to remote without force
- ✗ Don't use `git reset --hard` (destroys history)
- ✗ Don't force push unless absolutely necessary
