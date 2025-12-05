
The development team of xFusionCorp Industries is working on to develop a new static website and they are planning to deploy the same on Nautilus App Servers using Jenkins pipeline. They have shared their requirements with the DevOps team and accordingly we need to create a Jenkins pipeline job. Please find below more details about the task:

Click on the Jenkins button on the top bar to access the Jenkins Ul. Login using username admin and password Admin321.

Similarly, click on the Gitea button on the top bar to access the Ghea Ul. Login using username sarah and password Sarah pass123.

There is a repository named sarah/veb in Gitea that is already cloned on Storage server under /var/www/html directory.

1. Update the content of the file index.html under the same repository to come to FusionCorp Industries and push the chances to the oriain into
2. 2. Apache is already installed on all app Servers its running on port 8080

3. Create a Jenkins pipeline job named deploy-job (it must not be a Multibranch pipeline job) and pipeline should have two stages Deploy and Test (names are case sensitive). Configure these stages as per details mentioned below.

a. The Deploy stage should deploy the code from web repository under /var/www/html on the Storage Server, as this location is already mounted to the document root /var/www/html of all app servers.

b. The Test stage should just test if the app is working fine and website is accessible. Its up to you how you design this stage to test it out, you can simply add a curl command as well to run a curl against the LBR URL (http://stlb01:8091) to see if the website is working or not. Make sure this stage fails in case the website/app is not working or if the Deploy stage fails.
Click on the App button on the top bar to see the latest changes you deployed. Please make sure the required content is loading on the main URL htt//stlb01:8091 le there should not be a sub-directory like

http://stlb01:8091/web etc.

Note:
