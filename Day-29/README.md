## **Step-by-Step Solution**

### **Step 1: SSH into the storage server**

```bash
ssh max@<server-ip>
# Password: Max_pass123
```

* After login, check the cloned repository under Max’s home directory:

```bash
cd ~/repo_name   # replace repo_name with actual repo folder
ls -la
```

### **Step 2: Check contents of the repository**

* Check if Sarah’s story exists:

```bash
ls stories/   # or wherever stories are stored
```

* Validate commit history:

```bash
git log --oneline --author="Sarah"
git log
```

* Verify commit messages, authors, and timestamps.

### **Step 3: Confirm Max's branch**

* Max has already pushed his story to:

```
story/fox-and-grapes
```

* Verify:

```bash
git branch -r
git checkout story/fox-and-grapes
ls
```

---

### **Step 4: Create Pull Request (PR)**

1. Open the Gitea UI in a browser.
2. Log in with Max’s credentials:

   * Username: `max`
   * Password: `Max_pass123`
3. Navigate to the repository.
4. Click **Create Pull Request**.

   * PR title: `Added fox-and-grapes story`
   * Pull from branch (source): `story/fox-and-grapes`
   * Merge into branch (destination): `master`
5. Assign reviewer:

   * Click **Reviewers** on the right panel.
   * Add **Tom** as reviewer.

---

### **Step 5: Review and approve PR as Tom**

1. Logout from Max account.
2. Log in as Tom:

   * Username: `tom`
   * Password: `Tom_pass123`
3. Navigate to the PR: `Added fox-and-grapes story`
4. Review the story.
5. Approve the PR.
6. Merge the PR into `master`.

---

### **Step 6: Verify Merge**

* Log back as Max or Tom:

```bash
git checkout master
git pull origin master
git log --oneline
```

* Verify that the `fox-and-grapes` story is now part of the master branch.

---

### **Step 7: Take Screenshots or Record Screen**

* Capture screenshots of:

  * PR creation
  * Assigning reviewer
  * PR review and approval
  * Merged PR
* Optional: Use loom.com or any screen recording software.

---

## **README.md**

```markdown
# Git Pull Request Workflow Example

This repository demonstrates the proper workflow for adding content without directly pushing to the master branch. 

## Scenario
Max wants to add his story "The 🦊 Fox and Grapes 🍇" to the repository. Direct pushes to master are not allowed. The process involves:

1. Pushing changes to a feature branch (`story/fox-and-grapes`).
2. Creating a Pull Request (PR) in Gitea.
3. Assigning a reviewer (Tom) for approval.
4. Reviewing and merging the PR into master.

## Purpose
- Ensure code/content quality.
- Prevent unreviewed changes in master.
- Track history of contributions.

```

---

## **STEPS.md**

````markdown
# Step-by-Step Git PR Workflow

## Step 1: SSH into Server
```bash
ssh max@<server-ip>
# Password: Max_pass123
cd ~/repo_name
ls -la
````

## Step 2: Verify Repository Contents

```bash
ls stories/
git log --oneline --author="Sarah"
git log
```

## Step 3: Confirm Max's Branch

```bash
git branch -r
git checkout story/fox-and-grapes
ls
```

## Step 4: Create Pull Request in Gitea

1. Log in as Max.
2. Go to repository → Click **Create Pull Request**.
3. PR title: `Added fox-and-grapes story`
4. Source branch: `story/fox-and-grapes`
5. Destination branch: `master`
6. Assign Tom as reviewer.

## Step 5: Review and Merge as Tom

1. Logout Max → Login Tom
2. Navigate to PR: `Added fox-and-grapes story`
3. Review the content.
4. Approve the PR.
5. Merge PR into master.

## Step 6: Verify Merge

```bash
git checkout master
git pull origin master
git log --oneline
```

## Step 7: Documentation

* Take screenshots or record the workflow for reference.

