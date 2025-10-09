
# Steps to Reset Git Repository

## Navigate to the repository:
```
cd /usr/src/kodekloudrepos/news
```
## Mark repository as safe:
```
git config --global --add safe.directory /usr/src/kodekloudrepos/news
```
## Check the commit history:
```
git log --oneline
```
## Reset the branch to the desired commit (commit message: add data.txt file):
```

sudo git reset --hard <commit-id>
```

## Mark the remote repository as safe (if needed):
```

sudo git config --global --add safe.directory /opt/news.git
```

## Force push changes to remote:
```

sudo git push origin master --force
```

Verify commit history:
```

git log --oneline
```

The repository now contains only the initial commit and the add data.txt file commit, with all other commits removed.
