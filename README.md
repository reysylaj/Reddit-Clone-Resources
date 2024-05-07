# Reddit Clone Resources

## Table of Contents
1. [Terraform Setup](#terraform-setup)
2. [Installation](#installation)
3. [Usage](#usage)
4. [License](#license)

## Terraform Setup
This repository contains the infrastructure setup instructions for the Reddit Clone project, including the creation of the Jenkins and SonarQube EC2 instances using Terraform.

# Setup Instructions

## Prerequisites
Ensure the following are installed:
- Terraform
- AWS CLI

## Steps
1. **Create Reddit Clone Resources Folder**: 
   ```bash
   mkdir Reddit-Clone-Resources
   cd Reddit-Clone-Resources
   mkdir Jenkins-SonarQubeCube-VM
  
2. **Create Terraform Files**:
- Inside the "Jenkins-SonarQubeCube-VM" folder, create the following files:
  cd Jenkins-SonarQubeCube-VM
  touch main.tf provider.tf install.sh

3. **Edit Terraform Files**:
- Update main.tf with the following configuration:
## main.tf

provider "aws" {
  region = "your_aws_region"
}

resource "aws_instance" "jenkins_sonarqube" {
  ami           = "your_ami_id"
  instance_type = "t2.large"
  key_name      = "your_key_pair_name"
  security_groups = ["Jenkins-VM-SG"]

  tags = {
    Name = "Jenkins-SonarQube-Instance"
  }
}

resource "aws_security_group" "jenkins_vm_sg" {
  name        = "Jenkins-VM-SG"
  description = "Security group for Jenkins VM"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

- Update provider.tf with the following configuration:
## provider.tf

provider "aws" {
  region = "your_aws_region"
}

- Update install.sh script as needed for your setup.

4. **Configure AWS Credentials**:
- Create an IAM User with "administrator access" policy.
- Configure AWS CLI on your local system:
  aws configure

5. **Initialize Terraform**:
- In the terminal, navigate to the "Jenkins-SonarQubeCube-VM" folder.
- Run terraform init to initialize Terraform.

6. **Plan and Apply**:
- Run terraform plan to review the planned actions.
- If everything looks good, execute terraform apply -auto-approve to create the resources.

7. **Access Jenkins and SonarQube**:
- Once Terraform completes the setup, access the Jenkins and SonarQube instances using their respective public IPs.
- Verify Jenkins, Docker, and Trivy installations using relevant commands.

**Additional Notes**
Ensure you have the necessary permissions to create resources in AWS.
Review and customize the Terraform scripts according to your requirements.
Make sure to secure your AWS credentials and resources appropriately.

### Connecting to EC2 Instance using MobaXterm:
- Open MobaXterm.
- Click on "Session" in the top left corner and select "SSH".
- In the "Remote host" field, enter the public IP of your EC2 instance.
- In the "Advanced SSH settings" section, specify the username (typically "ubuntu" for AWS EC2 instances).
- Click "OK" to initiate the SSH connection.
- Once connected, you can run commands directly on the EC2 instance through the MobaXterm terminal interface.

# Jenkins Setup Instructions

This README provides step-by-step instructions for setting up Jenkins on an EC2 instance.

## Access Jenkins EC2 Instance

1. **Copy Public IP**:
   - Copy the public IP of the Jenkins EC2 instance.

2. **Browse Jenkins**:
   - Open a web browser and enter the Jenkins IP followed by port 8080 (e.g., http://<Jenkins_IP>:8080).

3. **Retrieve Initial Admin Password**:
   - Open a terminal and run the following command:
     ```bash
     sudo cat /var/lib/jenkins/secrets/initialAdminPassword
     ```
   - Copy the displayed password.

4. **Jenkins Initialization**:
   - Paste the initial admin password into the Jenkins login page.
   - Proceed with the setup, including installing suggested plugins.
   - Set up an admin username (e.g., "clouduser") and password.

## Install Required Plugins

1. **Navigate to Plugin Manager**:
   - Go to "Manage Jenkins" > "Manage Plugins" > "Available" tab.

2. **Search and Install Plugins**:
   - Search for and install the following plugins:
     - Eclipse Temurin Installer
     - SonarQube Scanner
     - Sonar Quality Gates
     - Quality Gates
     - NodeJS
     - Docker
     - Docker Commons
     - Docker Pipeline
     - Docker API
     - Docker Build Step
     - CloudBees Docker Build and Publish

## Configure Tools

1. **Navigate to Global Tool Configuration**:
   - Go to "Manage Jenkins" > "Global Tool Configuration".

2. **Install Required Tools**:
   - Install the following tools:
     - Node.js
     - JDK
     - Docker
     - SonarQube Scanner

# SonarQube Configuration and Integration with Jenkins

This README provides step-by-step instructions for configuring SonarQube and integrating it with Jenkins.

## Configure SonarQube

1. **Access SonarQube Web Interface**:
   - Copy the public IP address of the SonarQube EC2 instance.
   - Browse it using port 9000 (e.g., http://<SonarQube_IP>:9000).
   - Default username and password: admin - admin.

2. **Change SonarQube Admin Password**:
   - Log in to SonarQube and set a new password.

3. **Create SonarQube Token**:
   - Go to "Administration" > "Security" > "Users".
   - Click on your user, then click "Tokens".
   - Generate a token for Jenkins and copy it.

## Integrate SonarQube with Jenkins

1. **Add SonarQube Token to Jenkins Credentials**:
   - Go to Jenkins dashboard and navigate to "Manage Jenkins" > "Manage Credentials".
   - Click on "Global" > "Add Credentials".
   - Choose "Secret text" as the kind.
   - Paste the token copied from SonarQube.
   - Set an ID (e.g., SonarQube-Token) and click "OK".

2. **Add SonarQube Server to Jenkins Configuration**:
   - Go to "Manage Jenkins" > "Configure System".
   - Scroll down to "SonarQube servers" and click "Add SonarQube".
   - Enter a name (e.g., SonarQube-Server) and the SonarQube server URL (http://<private_ip>:9000).
   - Choose the created secret token for server authentication.
   - Click "Apply" and "Save" to save the configuration.

3. **Create SonarQube Quality Gate**:
   - Go to the SonarQube dashboard and navigate to "Quality Gates".
   - Click "Create" and give the Quality Gate a name (e.g., SonarQube Quality Gate).
   - Save the Quality Gate.

4. **Set Up Webhook in SonarQube**:
   - Go to "Administration" > "Configuration" > "Webhooks".
   - Click "Create" and enter a name (e.g., Jenkins).
   - Set the URL to http://<private_ip_of_ec2>:8080/sonarqube-webhook/.
   - Click "Create" to save the webhook configuration.

# Jenkins Pipeline Setup Instructions

This README provides step-by-step instructions for creating a Jenkins pipeline script (Jenkinsfile) and configuring a CI job on Jenkins.

## Configure Jenkins Credentials

1. **GitHub Credentials**:
   - Go to GitHub > Settings > Developer Settings > Personal access tokens.
   - Create a personal access token with appropriate permissions.
   - In Jenkins, go to "Manage Jenkins" > "Manage Credentials" > "Global" > "Add Credentials".
   - Select "Username with password" as the kind.
   - Enter your GitHub username and paste the generated personal access token.
   - Provide an ID (e.g., GitHub-Token) and description (e.g., GitHub).
   - Click "OK" to save the credentials.

2. **DockerHub Credentials**:
   - Go to DockerHub > Account Settings > Security.
   - Click on "New Access Token" and generate a token.
   - Copy the token to a safe location.
   - In Jenkins, add DockerHub credentials similar to GitHub credentials.

## Create Project on SonarQube

1. Go to SonarQube dashboard and navigate to "Projects".
2. Manually create a new project with the desired display name.
3. Proceed with the project setup, selecting appropriate options for analysis.

## Create Jenkins Pipeline Script (Jenkinsfile)

1. In your code repository, create a new file named "Jenkinsfile".
2. Add the following script to the "Jenkinsfile", updating as necessary:


3. Customize the pipeline script to include stages for cleaning workspace, checking out from Git, SonarQube analysis, quality gate, installing dependencies, Trivy FS scan, Docker build and push, and cleanup artifacts.

Create CI Job on Jenkins
1. Go to Jenkins dashboard and click "New Item".
2. Enter a name for the job (e.g., Reddit-Clone-CI) and select "Pipeline".
3. Configure job settings such as "Discard Old Builds" and "Max of Builds to Keep".
4. Choose "Pipeline script from SCM" and provide the repository URL.
5. Select the GitHub credentials and branch to build from.
6. Set the script path to the "Jenkinsfile" in your repository.
7. Click "Apply" and "Save" to create the job.

Build and Test
1. Click "Build Now" on the Jenkins job page to trigger a build.
2. Monitor the build status on Jenkins.
3. Check SonarQube for analysis results and issues found.
4. Ensure Docker image is pushed to DockerHub.

## Prerequisites

- Ensure your Google account is enabled with Two-Factor Authentication.
- Generate an App Password for Jenkins to use for sending emails.

## Configure Gmail Credentials in Jenkins

1. **Generate App Password**:
   - Go to [Google Account Security Settings](https://myaccount.google.com/security).
   - Navigate to "App passwords" and generate a new password. Save it securely.

2. **Add Gmail Credentials to Jenkins**:
   - In Jenkins, go to "Manage Jenkins" > "Manage Credentials".
   - Click on "Global" > "Add Credentials".
   - Select "Username with password" as the kind.
   - Enter your Gmail username and the generated App Password.
   - Provide an ID (e.g., gmail) and description (e.g., Gmail).
   - Click "OK" to save the credentials.

## Configure Email Notification in Jenkins

1. **SMTP Server Settings**:
   - Go to "Manage Jenkins" > "Configure System".
   - Scroll down to "E-mail Notification".
   - Set SMTP server to "smtp.gmail.com".
   - Provide the default user email suffix (e.g., @gmail.com).
   - Under "Advanced", set:
     - Username: Your Gmail username.
     - Password: The generated App Password.
     - Use SSL.
     - SMTP Port: 465.
   - Click "Test Configuration" to ensure it works.

2. **Extended Email Notification**:
   - Go to "Extended E-mail Notification" section.
   - Set SMTP server to "smtp.gmail.com" and port to "465".
   - Under "Advanced", select the Gmail credentials previously configured.
   - Use SSL and set the default user email.
   - Set "Default Content Type" to "HTML" and default triggers to "Always" and "Success".
   - Click "Apply" and "Save" to save the configuration.

## Update Pipeline Script (Jenkinsfile)

1. Open the Jenkinsfile containing your pipeline script for editing.
2. Add a "post" section after the stages to send email notifications:

```groovy
pipeline {
    agent any
    tools {
        jdk 'jdk17'
        nodejs 'node16'
    }
    environment {
        // Define environment variables
    }
    stages {
        // Define stages of your pipeline
    }
}
```

3. Customize the pipeline script to include stages for cleaning workspace, checking out from Git, SonarQube analysis, quality gate, installing dependencies, Trivy FS scan, Docker build and push, and cleanup artifacts.

Create CI Job on Jenkins
1. Go to Jenkins dashboard and click "New Item".
2. Enter a name for the job (e.g., Reddit-Clone-CI) and select "Pipeline".
3. Configure job settings such as "Discard Old Builds" and "Max of Builds to Keep".
4. Choose "Pipeline script from SCM" and provide the repository URL.
5. Select the GitHub credentials and branch to build from.
6. Set the script path to the "Jenkinsfile" in your repository.
7. Click "Apply" and "Save" to create the job.

Build and Test
1. Click "Build Now" on the Jenkins job page to trigger a build.
2. Monitor the build status on Jenkins.
3. Check SonarQube for analysis results and issues found.
4. Ensure Docker image is pushed to DockerHub.

# Email Notification Setup Through Jenkins

This README provides step-by-step instructions for setting up email notification through Jenkins.

## Prerequisites

- Ensure your Google account is enabled with Two-Factor Authentication.
- Generate an App Password for Jenkins to use for sending emails.

## Configure Gmail Credentials in Jenkins

1. **Generate App Password**:
   - Go to [Google Account Security Settings](https://myaccount.google.com/security).
   - Navigate to "App passwords" and generate a new password. Save it securely.

2. **Add Gmail Credentials to Jenkins**:
   - In Jenkins, go to "Manage Jenkins" > "Manage Credentials".
   - Click on "Global" > "Add Credentials".
   - Select "Username with password" as the kind.
   - Enter your Gmail username and the generated App Password.
   - Provide an ID (e.g., gmail) and description (e.g., Gmail).
   - Click "OK" to save the credentials.

## Configure Email Notification in Jenkins

1. **SMTP Server Settings**:
   - Go to "Manage Jenkins" > "Configure System".
   - Scroll down to "E-mail Notification".
   - Set SMTP server to "smtp.gmail.com".
   - Provide the default user email suffix (e.g., @gmail.com).
   - Under "Advanced", set:
     - Username: Your Gmail username.
     - Password: The generated App Password.
     - Use SSL.
     - SMTP Port: 465.
   - Click "Test Configuration" to ensure it works.

2. **Extended Email Notification**:
   - Go to "Extended E-mail Notification" section.
   - Set SMTP server to "smtp.gmail.com" and port to "465".
   - Under "Advanced", select the Gmail credentials previously configured.
   - Use SSL and set the default user email.
   - Set "Default Content Type" to "HTML" and default triggers to "Always" and "Success".
   - Click "Apply" and "Save" to save the configuration.

## Update Pipeline Script (Jenkinsfile)

1. Open the Jenkinsfile containing your pipeline script for editing.
2. Add a "post" section after the stages to send email notifications:

```groovy
post {
    always {
        emailext attachLog: true,
            subject: "'${currentBuild.result}'",
            body: "Project: ${env.JOB_NAME}<br/>" +
                "Build Number: ${env.BUILD_NUMBER}<br/>" +
                "URL: ${env.BUILD_URL}<br/>",
            to: 'your_email@gmail.com',                              
            attachmentsPattern: 'trivyfs.txt,trivyimage.txt'
    }
}
```

3. Customize the recipient email address and attachment pattern as needed.

Build and Test
1. Go to your pipeline project in Jenkins and click "Build Now".
2. Once the build completes, check your Gmail inbox for the email containing the build result and logs.


# AWS EKS Cluster Creation

This README provides step-by-step instructions for creating an AWS EKS cluster.

## 1. Install kubectl on Jenkins Server

```bash
sudo apt update
sudo apt install curl
curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```


2. Install AWS CLI
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

4. Install eksctl
```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /bin
eksctl version
```

6. Create IAM Role for EKS Cluster
1. Go to AWS console and navigate to IAM > Roles > Create role.
2. Choose "AWS service" and select EC2.
3. Attach the "AdministratorAccess" policy.
4. Name the role (e.g., eksctl_role) and create the role.
5. Go to EC2 instance, select the instance, go to Actions > Security > Modify IAM role, and select the created role.

5. Setup Kubernetes Cluster using eksctl
```
eksctl create cluster --name virtualtechbox-cluster \
--region ap-south-1 \
--node-type t2.small \
--nodes 3
```

7. Verify Cluster
```
kubectl get nodes
```


# Setup Monitoring for Kubernetes using Helm, Prometheus, and Grafana Dashboard

This README provides step-by-step instructions for setting up monitoring for Kubernetes using Helm, Prometheus, and Grafana dashboard.

## 1. Install Helm Chart

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
helm version
```

2. Add Helm Repositories
```
helm repo add stable https://charts.helm.sh/stable
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

3. Install Prometheus
```
kubectl create namespace prometheus
helm install stable prometheus-community/kube-prometheus-stack -n prometheus
kubectl get pods -n prometheus
kubectl get svc -n prometheus
```

4. Expose Prometheus and Grafana to External World
```
# Expose Prometheus
kubectl edit svc stable-kube-prometheus-sta-prometheus -n prometheus
# Change from Cluster IP to LoadBalancer, set port & targetport to 9090

# Expose Grafana
kubectl edit svc stable-grafana -n prometheus
# Change from Cluster IP to LoadBalancer

kubectl get svc -n prometheus
# Copy DNS name of LoadBalancer for Prometheus and Grafana
```

5. Access Grafana Dashboard
```
# Get Grafana Admin Password
kubectl get secret --namespace prometheus stable-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

# Access Grafana dashboard using the copied DNS name of LoadBalancer
# Browse to the Grafana dashboard and login with username "admin" and the password obtained above
```

6. Import Prometheus Dashboards
Import dashboard - 15760: Load, Select Prometheus, and Click Import.
Import dashboard - 12740: Load, Select Prometheus, and Click Import.


# ArgoCD Installation on Kubernetes Cluster and Adding AWS EKS Cluster

This README provides step-by-step instructions for installing ArgoCD on a Kubernetes cluster and adding an AWS EKS cluster to ArgoCD.

## 1. Create Namespace

```bash
kubectl create namespace argocd
```

2. Apply ArgoCD Configuration
```
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

3. View ArgoCD Pods
```
kubectl get pods -n argocd
```

4. Deploy ArgoCD CLI
```
sudo curl --silent --location -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.4.7/argocd-linux-amd64
sudo chmod +x /usr/local/bin/argocd
```

5. Expose argocd-server
```
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

6. Wait for LoadBalancer Creation
```
kubectl get svc -n argocd
# Wait about 2 minutes for the LoadBalancer creation
```

7. Get and Decode Initial Admin Password
```
kubectl get secret argocd-initial-admin-secret -n argocd -o yaml
echo WXVpLUg2LWxoWjRkSHFmSA== | base64 --decode
```

8. Login to ArgoCD from CLI
```
argocd login a2255bb2bb33f438d9addf8840d294c5-785887595.ap-south-1.elb.amazonaws.com --username admin
# Provide the decoded password obtained above
```

9. Check Available Clusters in ArgoCD
```
argocd cluster list
```

10. Show EKS Cluster Details
```
kubectl config get-contexts
```

11. Add EKS Cluster to ArgoCD
```
argocd cluster add i-08b9d0ff0409f48e7@virtualtechbox-cluster.ap-south-1.eksctl.io --name virtualtechbox-eks-cluster
```

12. Verify Cluster Addition
```
argocd cluster list
```

# Configure ArgoCD to Deploy Pods on EKS Cluster and Automate ArgoCD Deployment using GitOps GitHub Repository

This README provides step-by-step instructions for configuring ArgoCD to deploy pods on an EKS cluster and automating ArgoCD deployment using a GitOps GitHub repository.

## Deploy Application on ArgoCD

1. Go to ArgoCD settings.
2. Navigate to repositories and connect the repository via HTTPS.
3. Click on "New Application".
   - Application Name: Reddit clone app
   - Project Name: default
   - Sync Policy: Automatic
   - Source: Select the repository
   - Path: /cluster
   - Target Cluster: Select the EKS cluster
   - Click "Create".

## Automate Deployment Using GitOps Repository

1. Create a new Jenkins item.
   - Name: reddit-clone-CD
   - Discard Old Builds: 2
   - This project is parameterized:
     - Add a string parameter named "image tag".
   - Build Trigger: Select "Trigger build remotely".
   - Pipeline Definition: Select "Pipeline script from SCM".
   - SCM: Select Git and provide the GitOps repository URL and credentials.
   - Branch: Main
   - Click "Apply" and "Save".

2. Modify CI Job to Trigger CD Job Remotely.
   - Edit the Jenkinsfile for the CI job and add a new stage named "Trigger CD Pipeline".
   - Use the following script to trigger the CD pipeline remotely:
     ```bash
     curl -v -k --user clouduser:${JENKINS_API_TOKEN} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=${IMAGE_TAG}' 'ec2-13-36-167-236.eu-west-3.compute.amazonaws.com:8080/job/Reddit-Clone-CD/buildWithParameters?token=gitops-token'
     ```

3. Define Jenkins API Token.
   - Go to Jenkins dashboard and navigate to the user settings.
   - Under API Token, add a new token named "Jenkins API token" and generate a token.
   - Save the token in a secure location.

4. Configure Jenkins Credentials.
   - Go to Jenkins dashboard, navigate to manage Jenkins > credentials > add credentials.
   - Select kind "Secret text" and provide the Jenkins API token.
   - ID: Jenkins API token
   - Description: Jenkins API token
   - Click "Create".

5. Edit Jenkinsfile for CI Job.
   - Define the Jenkins API token variable in the Jenkinsfile.

6. Create Jenkinsfile for CD Job.
   - Create a Jenkinsfile in the GitOps repository with the following pipeline script.

```groovy
pipeline {
    agent any
    environment {
        APP_NAME = "reddit-clone-app"
    }
    stages {
        stage("Cleanup Workspace") {
            steps {
                cleanWs()
            }
        }
        stage("Checkout from SCM") {
            steps {
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/reysylaj/a-reddit-clone-gitops'
            }
        }
        stage("Update the Deployment Tags") {
            steps {
                sh """
                    cat deployment.yaml
                    sed -i 's/${APP_NAME}.*/${APP_NAME}:${IMAGE_TAG}/g' deployment.yaml
                    cat deployment.yaml
                """
            }
        }
    }
}
```

# Set the Trigger Using GitHub Webhook and Verify the CI/CD Pipeline

This guide provides instructions for setting up the trigger using GitHub webhook and verifying the CI/CD pipeline.

## Set GitHub Webhook Trigger

1. Go to the CI job configuration in Jenkins.
2. Under "Build Trigger," select "GitHub hook trigger."
3. Select "GitHub project" and provide the GitHub repository URL used in the CI job.
4. Go to the repository settings on GitHub, navigate to webhooks, and add a new webhook.
   - Payload URL: http://JENKINS_SERVER_IP:8080/github-webhook/
   - Add webhook.
5. Once added, verify the connection status (green tick) and click "Apply" and "Save" in Jenkins.

## Verify CI/CD Pipeline

1. Open Git Bash on your local system.
2. Run the following commands to configure your user and clone the code repository:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   git clone REPOSITORY_URL
   cd REPOSITORY_DIRECTORY

3. Make a test change to the README file to trigger the CI/CD pipeline:
nano README.md

Edit the file, save, and exit (Ctrl+O, Enter, Ctrl+X).
4. Stage, commit, and push the changes to the remote repository:
git add .
git commit -m "Test change for CI/CD pipeline"
git push

5. Verify the CI job is triggered automatically upon the change in the GitHub repository.
6. Once the CI job completes successfully, verify that the CD job is also triggered automatically.
7. Check the build number in the CI job, which should match the tag of the DockerHub image.
8. Access the application by browsing the DNS name with port 3000.
9. Check your email for notifications from the Jenkins pipeline containing Trivy scan results, build logs, etc.
10. Access Grafana dashboard and select the default namespace and Prometheus data source to monitor the Kubernetes cluster.

By following these steps, you can create a complete CI/CD pipeline project that operates in a fully automated manner. Any changes to the GitHub repository will trigger the CI job, and upon completion, the CD job will be automatically triggered. The CI job will push the Docker image with the latest release number, and the CD job will update the image tag in the Manifest file, resulting in applied changes to the application. You can monitor the entire Kubernetes cluster using Prometheus and Grafana dashboards.
