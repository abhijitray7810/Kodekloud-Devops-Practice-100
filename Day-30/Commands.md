# Login storage server
```
ssh natasha@ststor01
```
# Navigate to repository
```
dd /usr/src/kodekloudrepos/news
```

# Mark repository as safe directory
```
git config --global --add safe.directory /usr/src/kodekloudrepos/news
```

# Check commit history
```
git log --oneline
```

# Reset to commit with 'add data.txt file'
```
sudo git reset --hard 1f1d6ef
```

# Mark remote repository as safe (if needed)
```
sudo git config --global --add safe.directory /opt/news.git
```

# Push changes forcefully to remote
```
sudo git push origin master --force
```
