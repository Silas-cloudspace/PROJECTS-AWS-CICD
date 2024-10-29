# PROJECT: GITHUB ACTIONS  TERRAFORM / DOCKER / ECS

![image](https://github.com/user-attachments/assets/799a4b24-2d2e-4222-ba92-efc5cc41a7aa)

Full CI/CD project that walks you from beginning to end on how to deploy an application on AWS.

This project covers how to deploy applications in AWS using core AWS services such as:

•	VPC

•	RDS

•	ECS

•	ECR

•	S3

•	Public and private subnets

•	Nat Gateway

•	Security groups

•	Application Load Balancer

•	Auto scaling group

•	Route 53 

•	Certificate Manager

This project also covers containerization and show how to build a docker image and push the image into amazon ECR.

It also covers how to deploy an application in AWS using infrastructure as code, with Terraform as the tool used.

Finally, this project also shows how to deploy a dynamic application on AWS using CI/CD pipeline and GitHub Actions.

# PROJECT

We will start now start the project and create all the jobs in the image above in order to build our CI/CD pipeline.

These jobs will allow us to build a fully automated CI/CD pipeline to deploy any dynamic application on AWS.

On the above reference architecture, one thing I want to point out is the hosted runners. 

Runners in GitHub Actions refers to the machine you want to use to build the job. 

In this project we will use two types of runners to build our CI/CD pipeline:

GitHub hosted runner: A cloud-based virtual machine provided by GitHub for running automated workflows. We will use this machine to build our job and once we have used it to build our job the machine will go away.

Self-hosted runner: A runner that is set up and maintained by the user on their own infrastructure for running GitHub Actions workflow. This is a machine that we will create. By machine I mean the EC2 instance we will launch, and we will use that EC2 instance to build our job.

### Repositories:

https://github.com/Silas-cloudspace/WheelsOnDemand-github-actions-terraform-ecs

https://github.com/Silas-cloudspace/cicd-projects

https://github.com/Silas-cloudspace/application-codes-autorentify-project

## I.	Create a GitHub repository

I’ve named mine “WheelsOnDemand-github-actions-terraform-ecs”

## II.	Update the .gitignore file

Copy and paste the .gitignore file from the provided shared repository into it

git add .

git commit -m “update gitignore file”

git push

## III.	Add the Terraform code into the repository

Download the Terraform code: https://github.com/Silas-cloudspace/cicd-projects

Unzip it and paste the folder into the “WheelsOnDemand-github-actions-terraform-ecs” folder in your local computer

git add .

git commit -m “add iac files”

git push

* Remember to change the values in the “terraform.tf.vars” with your own values

## IV.	Create the remote backend

Now we will create an S3 bucket to store the Terraform state and a DynamoDB table to lock the Terraform state.

Navigate to remote_backend folder

cd remote_backend

terraform init

terraform apply

## V.	Create Secrets in AWS Secrets Manager

We will now add the value for our RDS database name, username, password, and also our ECR registry as secrets in Secrets Manager.

Go to AWS console and search for Secrets Manager

Click on “Store a new secret”
 
![image](https://github.com/user-attachments/assets/138e1380-069c-4cf3-9508-f3177555dcf7)

In order to get your Elastic Container Registry, open a new AWS tab, go to ECR and click on “Create repository”

![image](https://github.com/user-attachments/assets/6c8a932b-5a62-490b-9fc1-cfd70ac2ddb8)

Copy the ECR value and paste it on secrets manager.

![image](https://github.com/user-attachments/assets/f331ae89-3e50-4e16-8ca3-a9ba338ecfee)

You can click next on the following steps.

## VI.	Register a Domain name

Go to AWS Route 53 and create a new domain name for yourself. It will cost you around 14 dollars.

## VII.	Create a GitHub personal access token

This token will be used by docker to clone the application codes repository when we build our docker image

Github -> select your profile -> settings -> Developer settings -> Personal access tokens -> Tokens (classic) - > Generate new token -> Generate new token classic

Edit it as you see in the following example: 

![image](https://github.com/user-attachments/assets/3fb7210c-e5dc-4d52-9433-9d5f2449d12c)
 
Remember to copy your personal access token and save it anywhere

## VIII.	Create GitHub repository Secrets

Now we will create the repository secrets that the GitHub Action job need to build our cicd pipeline for this project.

Go to your GitHub repository

Click on settings

Navigate to “Secrets and variables”

Choose “actions”

Click on “New repository secret”

Add 7 secrets:

![image](https://github.com/user-attachments/assets/f9291b4c-02c0-4314-9e26-8a2f9cad8a1c)
 
Above you can find an example

•	AWS_ACCESS_KEY_ID - “Your AWS access key id”

•	AWS_SECRET_ACCESS_KEY – “Your secret AWS access key”

•	ECR_REGISTRY – 

In order to get your Elastic Container Registry, open a new AWS tab, go to ECR and click on “Create repository”
 
![image](https://github.com/user-attachments/assets/6d598a09-594d-481f-bfca-9d94623d5b04)

•	PERSONAL_ACCESS_TOKEN –  “The personal access token we created on point VII”

•	RDS_DB_NAME – Go to AWS console > Secrets Manager > select the secret we create before > Under secret value, click on “retrieve secret value”. Paste the rds_db_name “applicationdb” as the secret on GitHub.

 ![image](https://github.com/user-attachments/assets/3cd81501-235a-41a6-a378-2e6b75aa4ef5)

•	RDS_DB_USERNAME - RDS_DB_NAME – Go to AWS console > Secrets Manager > select the secret we create before > Under secret value, click on “retrieve secret value”. Paste the rds username you choose as the secret on GitHub.

•	RDS_DB_PASSWORD – RDS_DB_NAME – Go to AWS console > Secrets Manager > select the secret we create before > Under secret value, click on “retrieve secret value”. Paste the rds password you choose as the secret on GitHub.

## IX.	Create the GitHub Action Workflow file

Navigate to “WheelsOnDemand-github-actions-terraform-ecs” on VS Code

mkdir -p .github/workflows

cd .github/workflows

touch deploy_pipeline.yml

## X.	Create 3 GitHub Actions jobs

We will now create 3 GitHub Actions jobs: 

Configure AWS credentials – This job will be responsible for configuring our IAM credentials, to verify our access to AWS and authorize our GitHub Actions job to create new resources in our AWS account

Build AWS infrastructure – This job will use terraform and ubuntu hosted runner to build our infrastructure in AWS. This job will apply our terraform code and create all the AWS resources we will use.

Create ECR repository – This job will create an repository in ECR, which we will use to store our docker image for this project.

Copy the content from the shared repo into your deploy_pipeline.yml

Comment lines 12-16 in order to not run (we will make them run afterwards)

Comment everything that is after line 174 by pressing Shift + Alt + A

git add.

git commit -m “added github actions jobs”

git push

Check the pipeline under the “Actions” tab on your GitHub repo

## XI.	Create a Self-Hosted Runner

For the next job in our pipeline, we will start a self-hosted ec2 runner in the private subnet. We will use this runner for two things in our pipeline:

First, we will use the runner to build our docker image and push the docker image to the amazon ECR repository we created previously.

Then, we will also use this runner to run our database migration with flyway.

The reason why we are using a self-hosted runner to complete these jobs is because launching an ec2 runner in our private subnet will allow the runner to easily access the resources in our private subnet.

In this project we want to migrate our data into the RDS database so, by launching our EC2 in the private subnet, it allows that EC2 runner to easily connect to the RDS in the private subnet and migrate our data into it with flyway.

Once we have successfully migrated our data, we will terminate the ec2 runner immediately.

If we use the GitHub hosted runner, there wouldn’t be a way for that runner to connect to our RDS instance in the private subnet because, as you know, any resources we put in the private subnet may require additional configuration to access resources outside our private subnet.

Steps to create this action: https://github.com/machulav/ec2-github-runner

To summary we will need to:

1)	Create AWS access keys Pairs

2)	Create a GitHub personal access token (we have it)

3)	Prepare an EC2 image

4)	Use the EC2 instance to create an AMI

5)	Terminate the EC2 instance

Once we create our job to start our self-hosted runner, the job will use the AMI we created to start our self-hosted EC2 runner.

## XII.	Create AWS access keys Pairs

We will now create the keys pair that we will use to SSH into our EC2 instance.

Go to AWS Management Console > EC2 > Key Pairs > Create Key Pair

![image](https://github.com/user-attachments/assets/8df0a9b4-72ed-483a-b775-e8ae2cb3fa29)

## XIII.	Launch an EC2 instance in a public subnet

To create the AMI that we will use to start our self-hosted EC2 runner, the next thing we have to do is launch an EC2 instance in a public subnet.

Use the default VPC in our account to perform this action.

Go to AWS Management Console and create a new EC2 instance:
 
![image](https://github.com/user-attachments/assets/476aafd8-cf19-4267-8724-4d711095187b)
![image](https://github.com/user-attachments/assets/c0cc9a7e-0f8b-4507-9968-33b53808331a)
![image](https://github.com/user-attachments/assets/00244c33-6de9-4f82-ae74-7070fd3f1f70)

## XIV.	SSH into an EC2 Instance

Now that we have launched our EC2 instance, the next thing we have to do is SSH into the EC2 instance.

Copy the Public IPv4 address of the EC2 instance:
 
![image](https://github.com/user-attachments/assets/031f17cd-48aa-42ee-9ef9-d30214ff81bf)

Open a terminal in the same directory where you have stored your Key Pair and run the following:

ssh -i my-ec2-key.pem ec2-user@<public ipv4 address from ec2 instance>

## XV.	Install Docker and Git on the EC2 Instance

Once you have SSH into your EC2 instance, the next thing we have to do is paste, copy, and run the bellow commands in your ec2 instance:

They will install docker, git and enable the docker service on our EC2 instance

sudo yum update -y && \
sudo yum install docker -y && \
sudo yum install git -y && \
sudo yum install libicu -y && \
sudo systemctl enable docker

## XVI.	Create an AMI and Terminate the EC2 Instance

Now that we have installed docker, git and enabled the docker service on our EC2 instance, the next thing we will do is use this EC2 instance to create an AMI.

This is done so our GitHub Actions job use that AMI to start our self-hosted runner.

![image](https://github.com/user-attachments/assets/4e785a72-1f16-46bf-a951-4b5242bf6202)
![image](https://github.com/user-attachments/assets/700ecad2-e7cd-4dd6-932a-a61b59cd3714)

Wait for the status to become available and after that, confirm if a snapshot of the AMI was created on Elastic Block Store > Snapshots

Terminate your EC2 Instance

## XVII.	Create a GitHub Actions Job to Start a Self-Hosted Runner

We will now create the GitHub Actions job that we will use to start the self-hosted runner in the private subnet.

Remove the comments on the “deploy_pipeline.yml” file until line 215

git add.

git commit -m “start ec2 runner”

git push

## XVIII.	Create a GitHub Actions Job to Build a Docker Image

This job will build the docker image for our application and push the image to the amazon ECR repository we created previously.

Before creating the job to build the Docker Image, we need to complete these steps first:

1)	Set up a repository to store the application code and add the application code to the repository
2)	Create a Docker file
3)	Create the appserviceprovider.php file

### 1) Create a private repository to store the application codes 

Go to GitHub and create a new repository.

I’ve named mine “application-codes-autorentify-project”

Clone the repo to your local computer

Download the required file from this link: https://github.com/Silas-cloudspace/application-codes-autorentify-project

Add it to the repository folder in your local machine

Open the repository “application-codes-autorentify-project” on VS code

Push it to GitHub “application-codes-autorentify-project”

### 2) Create the Docker file

This is the file that our job will use to build the docker image for our application

Navigate to “WheelsOnDemand-github-actions-terraform-ecs” in VS Code

Create a new file: touch Dockerfile

Copy the content from the shared repo and paste it into it

### 3) Create the appserviceprovider.php file

This will be used to redirect HTTP traffic to HTTPS 

On “WheelsOnDemand-github-actions-terraform-ecs” directory create a new file:

touch AppServiceProvider.php

Copy the content from the shared repo and paste it into it

## XIX.	Create a GitHub Actions Job to Build and Push a Docker Image to ECR

Go to your “deploy_pipeline.yml” file

Remove the comments on lines 12-15 and on lines 216-265

git add . 

git commit -m “build docker image”

git push

## XX.	Create GitHub Actions Job to Export the Environment Variables into the S3 Bucket

This job will create in our pipeline will store all the build arguments we used to build the docker image in a file.

Once we have stored all the build arguments in a file, the job will copy the file into the S3 Bucket so that the ECS Fargate containers can reference the variables we stored in the file.

Go to your “deploy_pipeline.yml” file

Remove the comments from lines 266-300

git add . 

git commit -m “create env file”

git push

Now, if you go to the S3 bucket we just created and click on the file, you can either press download or open to download the file. When you open the file after downloaded you can see all of your build arguments as key/value pair. 

## XXI.	Create the SQL Folder and Add the SQL Script

We will now add the SQL script we want to migrate into our RDS database to our project folder.

Create a new folder in the “WheelsOnDemand-github-actions-terraform-ecs” directory

mkdir sql

Download the SQL script here:

https://drive.google.com/file/d/15W32C77oo9g4klXgfQJ7gULC_p1MPI0R/view?usp=share_link

Move it to the SQL folder in VS Code
 
![image](https://github.com/user-attachments/assets/f89a4ed9-beda-4e9a-a4ef-5871fbfdb2a0)

## XXII.	Create a GitHub Actions Job to Migrate Data into the RDS Database with Flyway

We will now use flyway to transfer the SQL data for our application into the RDS database in the next step in our pipeline.

This involves setting up flyway in our self-hosted runner and use it to move the data into RDS database.

Go to your “deploy_pipeline.yml” file

Remove the comments from lines 16, 301-339

This is the job we will use to migrate the data for our application into the RDS database using flyway

git add . 

git commit -m “migrate data”

git push

## XXIII.	Terminate the Self-Hosted Runner in AWS Console

After we launched the self-hosted runner to build our docker image and migrate the data for our application int the RDS database, we will terminate the self-hosted runner.

Before we create the job to terminate the self-hosted runner, first we will terminate the self-hosted runner that is currently running in the management console.

We are removing this self-hosted runner because when our pipeline runs again, the “migrate data job” will try to download flyway in the runner and the job will fail because we already have flyway installed on it.

That is why we are terminating it for now. But a new self-hosted runner will be created when our pipeline runs and the next job, we will create will terminate the self-hosted runner once it has completed the task it was created for.

Go to EC2 in the management console and delete(terminate) your ec2-github-runner.

## XXIV.	Create a GitHub Actions job to Stop the Self-Hosted EC2 Runner

Go to your “deploy_pipeline.yml” file

Remove the comments from lines 341-360

git add . 

git commit -m “stop runner”

git push

## XXV.	Create a GitHub Actions Job to Create a New Task Definition Revision

We will now create a new job to update the task definition for the ECS service hosted in our application with the new image we pushed into amazon ECR.

Go to your “deploy_pipeline.yml” file

Remove the comments from lines 363-401

git add . 

git commit -m “created td revision”

git push

## XXVI.	Create a GitHub Actions Job to Restart the ECS Fargate Service

We will now create the final job in our pipeline that will restart the ECS service and forces it to use the latest task definition revision we created previously.

Go to your “deploy_pipeline.yml” file

Remove the comments from lines 404-433

git add . 

git commit -m “restart ECS service”

git push

Go to the Web browser and paste your domain name. In my case: “cloudspace-consulting.com”












