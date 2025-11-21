# Jenkins Parameterized Job Setup Guide

## Overview
This guide documents the process of creating a simple parameterized Jenkins job for testing basic functionality of parameterized builds.

## Prerequisites
- Access to Jenkins UI
- Login credentials:
  - Username: `admin`
  - Password: `Adm!n321`

## Task Requirements

### Job Configuration
Create a parameterized Jenkins job with the following specifications:

1. **Job Name:** `parameterized-job`
2. **Parameters:**
   - **String Parameter:**
     - Name: `Stage`
     - Default Value: `Build`
   - **Choice Parameter:**
     - Name: `env`
     - Choices: 
       - Development
       - Staging
       - Production
3. **Build Step:** Execute shell command to echo both parameter values
4. **Validation:** Build the job at least once with choice parameter value `Staging`

## Step-by-Step Instructions

### 1. Access Jenkins
1. Click on the **Jenkins** button on the top bar
2. Login with the provided credentials

### 2. Create New Job
1. Click on **"New Item"** from the Jenkins dashboard
2. Enter the job name: `parameterized-job`
3. Select **"Freestyle project"**
4. Click **"OK"**

### 3. Configure String Parameter
1. In the job configuration page, check the box **"This project is parameterized"**
2. Click **"Add Parameter"** → Select **"String Parameter"**
3. Configure the parameter:
   - **Name:** `Stage`
   - **Default Value:** `Build`
   - **Description (optional):** "Build stage parameter"

### 4. Configure Choice Parameter
1. Click **"Add Parameter"** → Select **"Choice Parameter"**
2. Configure the parameter:
   - **Name:** `env`
   - **Choices:** (Enter each on a new line)
     ```
     Development
     Staging
     Production
     ```
   - **Description (optional):** "Environment selection"

### 5. Configure Build Step
1. Scroll down to the **"Build"** section
2. Click **"Add build step"** → Select **"Execute shell"**
3. Enter the following shell command:
   ```bash
   echo "Stage: ${Stage}"
   echo "Environment: ${env}"
   ```
4. Click **"Save"**

### 6. Build the Job
1. On the job page, click **"Build with Parameters"**
2. Set the parameters:
   - **Stage:** `Build` (or any custom value)
   - **env:** Select `Staging` from the dropdown
3. Click **"Build"**

### 7. Verify the Build
1. Click on the build number in the **"Build History"** section
2. Click **"Console Output"** to view the execution logs
3. Verify that the output displays:
   ```
   Stage: Build
   Environment: Staging
   ```

## Important Notes

### Plugin Installation
- If required plugins are missing, you may need to install them:
  1. Go to **"Manage Jenkins"** → **"Manage Plugins"**
  2. Navigate to the **"Available"** tab
  3. Search and select required plugins
  4. Check **"Restart Jenkins when installation is complete and no jobs are running"**
  5. Jenkins will restart automatically

### UI Refresh
- If Jenkins UI gets stuck during restart, refresh the browser page
- Wait for Jenkins to fully restart before attempting to access it

### Documentation
- Take screenshots of each configuration step for review purposes
- Consider using screen recording tools like [loom.com](https://loom.com) to record the entire process
- Save screenshots in a dedicated folder for easy reference

## Troubleshooting

### Common Issues

**Issue:** "This project is parameterized" option not visible
- **Solution:** Install the "Parameterized Trigger Plugin" if not already installed

**Issue:** Shell execution fails
- **Solution:** Ensure proper syntax in the shell command and verify parameter names match exactly

**Issue:** Parameters not showing during build
- **Solution:** Save the job configuration and refresh the page

## Validation Checklist

- [ ] Job created with name `parameterized-job`
- [ ] String parameter `Stage` added with default value `Build`
- [ ] Choice parameter `env` added with three choices
- [ ] Shell command configured to echo both parameters
- [ ] Job built successfully with `Staging` environment
- [ ] Console output shows correct parameter values
- [ ] Screenshots/recordings captured for documentation

## Expected Output

When the job is built with default string parameter and `Staging` environment, the console output should display:

```
Started by user admin
Running as SYSTEM
Building in workspace /var/jenkins_home/workspace/parameterized-job
[parameterized-job] $ /bin/sh -xe /tmp/jenkins...sh
+ echo Stage: Build
Stage: Build
+ echo Environment: Staging
Environment: Staging
Finished: SUCCESS
```

## Additional Resources

- [Jenkins Parameterized Builds Documentation](https://www.jenkins.io/doc/book/pipeline/syntax/#parameters)
- [Jenkins Best Practices](https://www.jenkins.io/doc/book/using/)

## Conclusion

This parameterized job serves as a basic example to understand how parameters can be passed to Jenkins jobs. This functionality is essential for creating flexible CI/CD pipelines that can adapt to different environments and configurations.
