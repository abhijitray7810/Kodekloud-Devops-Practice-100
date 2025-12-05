
# Jenkins Pipeline Deployment Guide
## xFusionCorp Industries - Static Website Deployment

This guide provides step-by-step instructions for deploying a static website using Jenkins pipeline on Nautilus App Servers.

---

## Prerequisites

- **Jenkins UI**: Accessible via Jenkins button (admin/Admin321)
- **Gitea UI**: Accessible via Gitea button (sarah/Sarah_pass123)
- **Repository**: sarah/web (already cloned to /var/www/html on Storage server)
- **Apache**: Running on port 8080 on all App Servers
- **Load Balancer URL**: http://stlb01:8091

---

## Step 1: Update Repository Content

### 1.1 Access Gitea
1. Click on the **Gitea** button in the top bar
2. Login with credentials:
   - Username: `sarah`
   - Password: `Sarah_pass123`

### 1.2 Update index.html
1. Navigate to the repository: `sarah/web`
2. Open the file `index.html`
3. Click **Edit** button
4. Update the content to: **Welcome to xFusionCorp Industries**
5. Add a commit message (e.g., "Updated welcome message")
6. Click **Commit Changes**

### 1.3 Alternative: Update via Storage Server
If you prefer command line:

```bash
# SSH to Storage Server
ssh <storage-server>

# Navigate to repository
cd /var/www/html

# Edit index.html
vi index.html
# or
echo "<h1>Welcome to xFusionCorp Industries</h1>" > index.html

# Commit and push changes
git add index.html
git commit -m "Updated welcome message"
git push origin master
```

---

## Step 2: Create Jenkins Pipeline Job

### 2.1 Access Jenkins
1. Click on the **Jenkins** button in the top bar
2. Login with credentials:
   - Username: `admin`
   - Password: `Admin321`

### 2.2 Create New Pipeline Job
1. Click **New Item** from Jenkins dashboard
2. Enter item name: `deploy-job`
3. Select **Pipeline** (NOT Multibranch Pipeline)
4. Click **OK**

### 2.3 Configure Pipeline

#### General Configuration
- Add description: "Deploy static website from Gitea to App Servers"

#### Pipeline Definition
Select **Pipeline script** and paste the following:

```groovy
pipeline {
    agent any
    
    stages {
        stage('Deploy') {
            steps {
                script {
                    echo "Starting deployment to Storage Server..."
                    
                    // Deploy code to Storage Server
                    sh '''
                        # SSH to Storage Server and pull latest changes
                        ssh -o StrictHostKeyChecking=no <storage-user>@<storage-server> << 'EOF'
                        cd /var/www/html
                        git pull origin master
                        echo "Code deployed successfully to /var/www/html"
EOF
                    '''
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    echo "Testing website accessibility..."
                    
                    // Test if website is accessible via Load Balancer
                    sh '''
                        # Wait a moment for deployment to complete
                        sleep 2
                        
                        # Test website accessibility
                        response=$(curl -s -o /dev/null -w "%{http_code}" http://stlb01:8091)
                        
                        if [ $response -eq 200 ]; then
                            echo "Website is accessible! HTTP Status: $response"
                            
                            # Check if content contains expected text
                            content=$(curl -s http://stlb01:8091)
                            if echo "$content" | grep -q "xFusionCorp Industries"; then
                                echo "Content verification successful!"
                            else
                                echo "Content verification failed - expected text not found"
                                exit 1
                            fi
                        else
                            echo "Website is not accessible! HTTP Status: $response"
                            exit 1
                        fi
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo "Deployment and testing completed successfully!"
        }
        failure {
            echo "Deployment or testing failed. Please check the logs."
        }
    }
}
```

#### Alternative Simplified Pipeline (if SSH keys are not configured)

```groovy
pipeline {
    agent any
    
    stages {
        stage('Deploy') {
            steps {
                script {
                    echo "Starting deployment..."
                    
                    // Clone/Pull repository to Storage Server
                    sh '''
                        # Assuming Jenkins has access to Storage Server
                        cd /var/www/html || exit 1
                        git config --global user.email "jenkins@xfusioncorp.com"
                        git config --global user.name "Jenkins"
                        
                        # Pull latest changes
                        git pull origin master
                        
                        echo "Deployment completed"
                    '''
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    echo "Testing deployment..."
                    
                    // Test website
                    sh '''
                        sleep 3
                        
                        # Test HTTP response
                        HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://stlb01:8091)
                        
                        if [ "$HTTP_STATUS" = "200" ]; then
                            echo "✓ Website is accessible (HTTP $HTTP_STATUS)"
                            
                            # Verify content
                            if curl -s http://stlb01:8091 | grep -i "xFusionCorp Industries"; then
                                echo "✓ Content verification passed"
                                exit 0
                            else
                                echo "✗ Content verification failed"
                                exit 1
                            fi
                        else
                            echo "✗ Website not accessible (HTTP $HTTP_STATUS)"
                            exit 1
                        fi
                    '''
                }
            }
        }
    }
    
    post {
        always {
            echo "Pipeline execution completed"
        }
        success {
            echo "✓ Deployment successful - Website is live!"
        }
        failure {
            echo "✗ Deployment failed - Please check logs"
        }
    }
}
```

### 2.4 Save Configuration
Click **Save** to create the pipeline job

---

## Step 3: Execute Pipeline

### 3.1 Run the Job
1. From the Jenkins dashboard, click on `deploy-job`
2. Click **Build Now** in the left sidebar
3. Monitor the build progress in **Build History**
4. Click on the build number (e.g., #1) to view details
5. Click **Console Output** to see detailed logs

### 3.2 Verify Stages
The pipeline should execute two stages:
- **Deploy**: Pulls latest code to /var/www/html on Storage Server
- **Test**: Verifies website is accessible via http://stlb01:8091

---

## Step 4: Verify Deployment

### 4.1 Check Website
1. Click on the **App** button in the top bar
2. Verify the website loads at: `http://stlb01:8091`
3. Confirm the content shows: **Welcome to xFusionCorp Industries**

### 4.2 Manual Verification
```bash
# Test from command line
curl http://stlb01:8091

# Expected output should contain:
# "Welcome to xFusionCorp Industries"
```

---

## Troubleshooting

### Issue: Deploy Stage Fails

**Problem**: Git pull fails or permission denied

**Solution**:
```bash
# Check repository status on Storage Server
ssh <storage-server>
cd /var/www/html
git status
git pull origin master

# Fix permissions if needed
sudo chown -R <jenkins-user>:root /var/www/html
```

### Issue: Test Stage Fails

**Problem**: HTTP 404 or Connection Refused

**Solution**:
```bash
# Check Apache status on App Servers
systemctl status httpd

# Verify Apache is running on port 8080
netstat -tulpn | grep 8080

# Check document root configuration
cat /etc/httpd/conf/httpd.conf | grep DocumentRoot

# Restart Apache if needed
systemctl restart httpd
```

### Issue: Content Not Loading

**Problem**: Website shows directory listing or 403 Forbidden

**Solution**:
```bash
# Ensure index.html exists in /var/www/html
ls -la /var/www/html/index.html

# Check file permissions
chmod 644 /var/www/html/index.html

# Verify DirectoryIndex in Apache config
grep DirectoryIndex /etc/httpd/conf/httpd.conf
```

### Issue: SSH Key Issues in Pipeline

**Problem**: Pipeline cannot SSH to Storage Server

**Solution**:
```bash
# Generate SSH key for Jenkins user
sudo su - jenkins
ssh-keygen -t rsa -b 4096

# Copy public key to Storage Server
ssh-copy-id <storage-user>@<storage-server>

# Test connection
ssh <storage-user>@<storage-server> "echo 'Connection successful'"
```

---

## Important Notes

1. **Repository Location**: The sarah/web repository must be cloned to `/var/www/html` on Storage Server
2. **Mount Point**: `/var/www/html` on Storage Server is mounted to all App Servers' document roots
3. **Apache Port**: All App Servers run Apache on port 8080
4. **Load Balancer**: Access via `http://stlb01:8091` (not individual app servers)
5. **No Subdirectories**: Website must be accessible at root URL, not `/web` subdirectory
6. **Stage Names**: Must be exactly "Deploy" and "Test" (case-sensitive)

---

## Pipeline Architecture

```
Gitea Repository (sarah/web)
         ↓
   [Deploy Stage]
         ↓
Storage Server (/var/www/html) ← Git Pull
         ↓
   (NFS/Mounted)
         ↓
App Servers (/var/www/html) ← Apache serves content
         ↓
Load Balancer (stlb01:8091)
         ↓
   [Test Stage] ← Curl verification
```

---

## Success Criteria

- ✓ index.html updated with "Welcome to xFusionCorp Industries"
- ✓ Changes pushed to Gitea repository
- ✓ Jenkins pipeline job named "deploy-job" created
- ✓ Pipeline has exactly two stages: "Deploy" and "Test"
- ✓ Deploy stage successfully pulls code to /var/www/html
- ✓ Test stage verifies website accessibility
- ✓ Website accessible at http://stlb01:8091
- ✓ Content displays correctly without subdirectory paths

---

## Additional Resources

- **Jenkins Documentation**: https://www.jenkins.io/doc/
- **Git Documentation**: https://git-scm.com/doc
- **Apache HTTP Server**: https://httpd.apache.org/docs/

---

## Author
DevOps Team - xFusionCorp Industries

## Last Updated
December 2025
