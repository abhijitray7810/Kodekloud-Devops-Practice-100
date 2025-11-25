# Jenkins Job Permissions Setup Guide

## Objective
Grant specific permissions to developers `sam` and `rohan` to access the existing `Packages` job in Jenkins.

## Prerequisites
- Jenkins URL accessible via the "Jenkins" button in the top bar
- Admin credentials: `admin` / `Adm!n321`
- Existing users: `sam` (password: `sam@pass12345`) and `rohan` (password: `rohan@pass12345`)
- Existing job: `Packages`

---

## Step-by-Step Instructions

### Step 1: Access Jenkins
1. Click on the **Jenkins** button in the top bar
2. Login with credentials:
   - **Username:** `admin`
   - **Password:** `Adm!n321`
3. You should now be on the Jenkins dashboard

### Step 2: Install Required Plugin (Matrix Authorization Strategy Plugin)
To grant project-specific permissions, you'll need the Matrix Authorization Strategy Plugin.

1. Navigate to **Manage Jenkins** (from the left sidebar)
2. Click on **Manage Plugins** (or **Plugin Manager** in newer versions)
3. Go to the **Available** tab
4. Search for: `Matrix Authorization Strategy Plugin`
5. Check the box next to the plugin
6. Click **Install without restart** or **Download now and install after restart**
7. **Important:** Check the box that says **"Restart Jenkins when installation is complete and no jobs are running"**
8. Wait for Jenkins to restart
9. **Refresh your browser** if the UI appears stuck after restart
10. Login again with admin credentials if needed

### Step 3: Navigate to the Packages Job
1. From the Jenkins dashboard, locate and click on the **Packages** job
2. Click on **Configure** from the left sidebar menu

### Step 4: Enable Project-Based Security
1. Scroll down to the **General** section (near the top of the configuration page)
2. Look for the checkbox labeled **"Enable project-based security"**
3. Check this box to enable it
4. A security matrix should appear below

### Step 5: Set Inheritance Strategy
1. In the security matrix section, locate the **Inheritance Strategy** dropdown
2. Select: **"Inherit permissions from parent ACL"**
   - This ensures users inherit base permissions before project-specific permissions are applied

### Step 6: Grant Permissions to User 'sam'
1. In the **User/group to add** field, type: `sam`
2. Click **Add** button
3. A new row for user `sam` will appear in the matrix
4. Grant the following permissions by checking the appropriate boxes:
   - ✅ **Job/Build** - Allows sam to trigger builds
   - ✅ **Job/Configure** - Allows sam to modify job configuration
   - ✅ **Job/Read** - Allows sam to view the job

**Permission Matrix for sam:**
```
User: sam
├── Job
│   ├── ✅ Build
│   ├── ✅ Configure
│   └── ✅ Read
```

### Step 7: Grant Permissions to User 'rohan'
1. In the **User/group to add** field, type: `rohan`
2. Click **Add** button
3. A new row for user `rohan` will appear in the matrix
4. Grant the following permissions by checking the appropriate boxes:
   - ✅ **Job/Build** - Allows rohan to trigger builds
   - ✅ **Job/Cancel** - Allows rohan to cancel running builds
   - ✅ **Job/Configure** - Allows rohan to modify job configuration
   - ✅ **Job/Read** - Allows rohan to view the job
   - ✅ **Job/Update** - Allows rohan to update job configuration
   - ✅ **SCM/Tag** - Allows rohan to tag builds in source control

**Permission Matrix for rohan:**
```
User: rohan
├── Job
│   ├── ✅ Build
│   ├── ✅ Cancel
│   ├── ✅ Configure
│   ├── ✅ Read
│   └── ✅ Update
└── SCM
    └── ✅ Tag
```

### Step 8: Save Configuration
1. Scroll to the bottom of the page
2. Click **Save** button
3. You should be redirected to the Packages job page

### Step 9: Verify Permissions
To verify the permissions have been applied correctly:

**Test with sam:**
1. Logout from admin account
2. Login as `sam` / `sam@pass12345`
3. Navigate to the Packages job
4. Verify sam can:
   - View the job (Read)
   - Click "Build Now" (Build)
   - Access "Configure" option (Configure)
5. Logout

**Test with rohan:**
1. Login as `rohan` / `rohan@pass12345`
2. Navigate to the Packages job
3. Verify rohan can:
   - View the job (Read)
   - Click "Build Now" (Build)
   - Cancel a running build if any (Cancel)
   - Access "Configure" option (Configure)
   - See update and tag options (Update, Tag)
4. Logout

---

## Summary of Permissions

| User   | Build | Cancel | Configure | Read | Update | Tag |
|--------|-------|--------|-----------|------|--------|-----|
| sam    | ✅    | ❌     | ✅        | ✅   | ❌     | ❌  |
| rohan  | ✅    | ✅     | ✅        | ✅   | ✅     | ✅  |

---

## Important Notes

1. **Do NOT modify** any other existing job configurations
2. **Inheritance Strategy** must be set to "Inherit permissions from parent ACL"
3. If Jenkins UI gets stuck after restart, **refresh the browser page**
4. Always **take screenshots** of each step for documentation purposes
5. Consider using screen recording tools like [loom.com](https://loom.com) to record your work
6. If the Matrix Authorization Strategy Plugin is already installed, skip Step 2

---

## Troubleshooting

### Plugin Installation Issues
- If the plugin doesn't appear in Available tab, check the **Installed** tab - it might already be installed
- If installation fails, check Jenkins logs for errors
- Ensure Jenkins has internet connectivity to download plugins

### Permission Issues
- If users cannot see the job after granting permissions, verify:
  - "Enable project-based security" is checked
  - User names are spelled correctly (case-sensitive)
  - "Inherit permissions from parent ACL" is selected
  - Permissions are saved properly

### UI Not Responding After Restart
- Wait 1-2 minutes for Jenkins to fully restart
- Hard refresh the browser (Ctrl+F5 or Cmd+Shift+R)
- Clear browser cache if needed
- Try accessing Jenkins in a new incognito/private window

---

## Screenshot Checklist

Capture screenshots of the following:
- [ ] Jenkins login page
- [ ] Plugin installation page showing Matrix Authorization Strategy Plugin
- [ ] Jenkins restart confirmation
- [ ] Packages job configuration page
- [ ] "Enable project-based security" checkbox enabled
- [ ] Inheritance Strategy dropdown set to "Inherit permissions from parent ACL"
- [ ] Permission matrix showing sam's permissions
- [ ] Permission matrix showing rohan's permissions
- [ ] Final configuration before clicking Save
- [ ] Packages job page after saving (showing successful configuration)
- [ ] Verification login as sam (showing accessible features)
- [ ] Verification login as rohan (showing accessible features)

---

## Completion Criteria

✅ Matrix Authorization Strategy Plugin installed (if not already present)  
✅ Project-based security enabled for Packages job  
✅ Inheritance strategy set to "Inherit permissions from parent ACL"  
✅ User `sam` has Build, Configure, and Read permissions  
✅ User `rohan` has Build, Cancel, Configure, Read, Update, and Tag permissions  
✅ Configuration saved successfully  
✅ Permissions verified by logging in as both users  
✅ Screenshots/recording captured for review  

---

**Task Completed By:** _________________  
**Date:** _________________  
**Screenshots/Recording Location:** _________________
