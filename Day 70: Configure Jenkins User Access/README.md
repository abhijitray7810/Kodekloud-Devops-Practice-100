# Jenkins User Access Configuration Guide

## Overview
This guide provides step-by-step instructions for configuring user access and permissions in Jenkins using Project-based Matrix Authorization Strategy. This setup is part of the Nautilus team's CI/CD pipeline integration.

## Prerequisites
- Jenkins server installed and running
- Admin access credentials
- Access to Jenkins UI via browser

## Admin Credentials
- **Username:** `admin`
- **Password:** `Adm!n321`

## Objectives
1. Create a new Jenkins user account
2. Configure Project-based Matrix Authorization Strategy
3. Set appropriate permissions for users
4. Secure the Jenkins instance by removing anonymous access

---

## Step-by-Step Configuration

### Step 1: Access Jenkins UI

1. Click on the **Jenkins** button on the top bar to open the Jenkins interface
2. Login using the admin credentials provided above
3. You should see the Jenkins dashboard after successful login

---

### Step 2: Create New User 'kareem'

1. From the Jenkins dashboard, click **Manage Jenkins** (left sidebar)
2. Click **Manage Users**
3. Click **Create User** button
4. Fill in the user details:
   - **Username:** `kareem`
   - **Password:** `dCV3szSGNA`
   - **Confirm password:** `dCV3szSGNA`
   - **Full name:** `Kareem`
   - **E-mail address:** (optional - can leave blank or use `kareem@example.com`)
5. Click **Create User**

📸 **Screenshot checkpoint:** Capture the user creation confirmation

---

### Step 3: Install Matrix Authorization Strategy Plugin

**Note:** This plugin may already be installed. If so, skip to Step 4.

1. Navigate to **Manage Jenkins** → **Manage Plugins**
2. Click on the **Available** tab
3. In the search box, type: `Matrix Authorization Strategy Plugin`
4. Check the box next to the plugin
5. Click **Install without restart** or **Download now and install after restart**
6. After installation, select: ✅ **Restart Jenkins when installation is complete and no jobs are running**
7. **IMPORTANT:** Wait for the Jenkins login page to reappear before proceeding
8. Do **NOT** click "Finish" immediately after the restart

⏳ **Wait time:** Jenkins restart may take 30-60 seconds

---

### Step 4: Configure Global Security Settings

1. After Jenkins restarts, log back in as `admin`
2. Go to **Manage Jenkins** → **Configure Global Security**
3. Scroll down to the **Authorization** section
4. Select: **Project-based Matrix Authorization Strategy**

---

### Step 5: Configure Permission Matrix

In the Authorization matrix, configure the following permissions:

#### For User: `admin`
- Grant **Administer** permission (under Overall section)
  - This checkbox will automatically grant all permissions

#### For User: `kareem`
1. Click **Add user or group**
2. Type `kareem` and click **OK**
3. Grant **only** the following permission:
   - ✅ **Overall → Read**

#### For User: `Anonymous`
- **Remove ALL permissions** (uncheck all boxes)
- If Anonymous user doesn't exist in the matrix, no action needed

📸 **Screenshot checkpoint:** Capture the permission matrix showing all three users/groups

---

### Step 6: Configure Job-Level Permissions

For each existing job in Jenkins:

1. Go to the job's main page
2. Click **Configure** (left sidebar)
3. Scroll down and enable: ✅ **Enable project-based security**
4. In the project permission matrix:
   - Click **Add user or group**
   - Type `kareem` and click **OK**
   - Grant **only** the following permission:
     - ✅ **Job → Read**
5. **Do NOT grant** permissions for:
   - Agent
   - SCM
   - Build
   - Configure
   - Delete
   - Any other categories
6. Click **Save**

📸 **Screenshot checkpoint:** Capture the job configuration showing kareem's read-only access

---

### Step 7: Save and Verify Configuration

1. Click **Save** at the bottom of the Configure Global Security page
2. You should be redirected to the Manage Jenkins page
3. **Verification steps:**
   - Log out from the admin account
   - Attempt to log in as `kareem` using password `dCV3szSGNA`
   - Verify that kareem can:
     - ✅ View the Jenkins dashboard
     - ✅ View existing jobs
     - ❌ Cannot create new jobs
     - ❌ Cannot configure jobs
     - ❌ Cannot access admin settings

---

## Permission Summary

| User/Group | Overall Permissions | Job Permissions | Access Level |
|------------|-------------------|-----------------|--------------|
| **admin** | Administer (All) | All | Full administrative access |
| **kareem** | Read only | Read only | View-only access |
| **Anonymous** | None | None | No access |

---

## Documentation Best Practices

### Screenshots Required
Capture screenshots of:
1. ✅ User creation confirmation for 'kareem'
2. ✅ Global Security configuration showing Matrix Authorization Strategy
3. ✅ Permission matrix displaying admin, kareem, and anonymous settings
4. ✅ Job configuration showing kareem's read-only permissions

### Screen Recording (Recommended)
Consider using [loom.com](https://www.loom.com) to record:
- The entire configuration process
- Permission verification testing
- Login testing with the kareem account

This recording can serve as:
- Training material for team members
- Audit documentation
- Troubleshooting reference

---

## Troubleshooting

### Issue: Plugin Installation Failed
**Solution:** 
- Check internet connectivity
- Verify Jenkins has access to the plugin repository
- Try manual plugin installation from Jenkins website

### Issue: Cannot Find Matrix Authorization Strategy
**Solution:**
- Ensure the plugin is installed correctly
- Restart Jenkins service manually if needed
- Check **Installed** tab in Manage Plugins

### Issue: Admin Locked Out After Configuration
**Solution:**
- Access Jenkins server directly
- Edit `config.xml` in Jenkins home directory
- Temporarily disable security or reset to default

### Issue: kareem Cannot Login
**Solution:**
- Verify password was entered correctly: `dCV3szSGNA`
- Check that user was created successfully in Manage Users
- Ensure Overall Read permission is granted

---

## Security Notes

⚠️ **Important Security Considerations:**

1. **Password Management:** Store the kareem user password securely
2. **Regular Audits:** Periodically review user permissions
3. **Principle of Least Privilege:** Only grant necessary permissions
4. **Anonymous Access:** Keep disabled to prevent unauthorized access
5. **Admin Account:** Protect admin credentials carefully

---

## Additional Resources

- [Jenkins Documentation - Security](https://www.jenkins.io/doc/book/security/)
- [Matrix Authorization Strategy Plugin](https://plugins.jenkins.io/matrix-auth/)
- [Jenkins User Management](https://www.jenkins.io/doc/book/managing/users/)

---

## Verification Checklist

Before completing this task, verify:

- [ ] User 'kareem' created successfully
- [ ] Matrix Authorization Strategy Plugin installed
- [ ] Project-based Matrix Authorization Strategy enabled
- [ ] Admin has Administer permissions
- [ ] Kareem has Overall Read permission only
- [ ] Anonymous users have no permissions
- [ ] Kareem has Job Read permission for existing jobs
- [ ] Screenshots captured
- [ ] Configuration tested by logging in as kareem

---

## Support

For issues or questions regarding this configuration:
- Contact: Nautilus DevOps Team
- Documentation: Internal Wiki
- Jenkins Admin: admin@nautilus.local

---

**Configuration Date:** _Add date when completed_  
**Configured By:** _Add your name_  
**Reviewed By:** _Add reviewer name_

---

*This document is part of the Nautilus CI/CD pipeline setup initiative.*
