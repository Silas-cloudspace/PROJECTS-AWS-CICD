# CAR RENTAL DYNAMIC WEB APP HOSTED ON AWS USING GITHUB ACTIONS /TERRAFORM / DOCKER / ECS

Full CI/CD project on how to deploy an application on AWS.

This project covers how to deploy applications in AWS using various core AWS services.

This project also covers containerization and show how to build a docker image and push the image into amazon ECR.

It also covers how to deploy an application in AWS using infrastructure as code, with Terraform as the tool we used.

Finally, this project also shows how to deploy a dynamic application on AWS using CI/CD pipeline and GitHub Actions.

![image](https://github.com/user-attachments/assets/a3c86918-264b-41ca-95ed-0fd95890bbe1)

We will start now start the project and create all the jobs in the image above in order to build our CI/CD pipeline.

These jobs will allow us to build a fully automated CI/CD pipeline to deploy any dynamic application on AWS.

On the above reference architecture, one thing I want to point out is the hosted runners.

Runners in GitHub Actions refers to the machine you want to use to build the job.

In this project we will use two types of runners to build our CI/CD pipeline:

GitHub hosted runner: A cloud-based virtual machine provided by GitHub for running automated workflows. We will use this machine to build our job and once we have used it to build our job the machine will go away.

Self-hosted runner: A runner that is set up and maintained by the user on their own infrastructure for running GitHub Actions workflow. This is a machine that we will create. By machine I mean the EC2 instance we will launch, and we will use that EC2 instance to build our job.

## I. Create a GitHub repository

I’ve named mine “car_rental_dynamic_web_app”

## II. Update the .gitignore file

Copy and paste the .gitignore file from the provided shared repository into it

git add .

git commit -m “update gitignore file”

git push

### III. Create the Infrastructure with Terraform

Download the Terraform code: https://github.com/Silas-cloudspace/PROJECTS-AWS-CICD/tree/main/car_rental_dynamic_web_app/iac

Use the following link to download directories from GitHub: https://downgit.evecalm.com/#/home

Unzip it and paste the folder into the “car_rental_dynamic_web_app” folder in your local computer.

Remember to go to the “remote_backend” folder, change the values as you prefer and run terraform init and push.

After, navigate to the “car_rental_dynamic_web_app” directory, add the values to the backend.tf file and also change what needs to be changed in the other files. Such as “s3”, “region”, “terraform.tf.vars”, etc…

git add .

git commit -m “add iac files”

git push

## IV. Create Secrets in AWS Secrets Manager

We will now add the value for our RDS database name, username, password, and also our ECR registry as secrets in Secrets Manager.

Go to AWS console and search for Secrets Manager

Click on “Store a new secret”

![image](https://github.com/user-attachments/assets/6d0ad81c-1b46-44bc-a7c3-1e9073e8a7d9)

In order to get your Elastic Container Registry, open a new AWS tab, go to ECR and click on “Create repository”

![image](https://github.com/user-attachments/assets/25a812f3-2a83-4195-937c-6b909a2c814d)

Copy the ECR value and paste it on secrets manager.

![image](https://github.com/user-attachments/assets/e4bc1465-bed8-4a7b-a6ef-e4e4286f2b59)

You can click next on the following steps.

## V. Register a Domain name

Go to AWS Route 53 and create a new domain name for yourself. It will cost you around 14 dollars.

## VI. Create a GitHub personal access token

This token will be used by docker to clone the application codes repository when we build our docker image

Github -> select your profile -> settings -> Developer settings -> Personal access tokens -> Tokens (classic) → Generate new token -> Generate new token classic

Edit it as you see in the following example:

![image](https://github.com/user-attachments/assets/5ed30d12-424f-4c96-afcd-0fbb2771f33d)

Remember to copy your personal access token and save it anywhere

## VII. Create GitHub repository Secrets

Now we will create the repository secrets that the GitHub Action job need to build our cicd pipeline for this project.

Go to your GitHub repository

Click on settings

Navigate to “Secrets and variables”

Choose “actions”

Click on “New repository secret”

Add 7 secrets:

![image](https://github.com/user-attachments/assets/731b1479-319d-47be-8201-e9fe013de021)

· AWS_ACCESS_KEY_ID — “Your AWS access key id”

· AWS_SECRET_ACCESS_KEY — “Your secret AWS access key”

· ECR_REGISTRY –

In order to get your Elastic Container Registry, open a new AWS tab, go to ECR and click on “Create repository”

![image](https://github.com/user-attachments/assets/1d8d0de4-a385-49a2-931a-cc6bb9778cbf)

· PERSONAL_ACCESS_TOKEN — “The personal access token we created on point VII”

· RDS_DB_NAME — Go to AWS console > Secrets Manager > select the secret we create before > Under secret value, click on “retrieve secret value”. Paste the rds_db_name “applicationdb” as the secret on GitHub.

![image](https://github.com/user-attachments/assets/2af72485-4ef9-4abf-8c7e-9cd9edcbe969)

· RDS_DB_USERNAME — RDS_DB_NAME — Go to AWS console > Secrets Manager > select the secret we create before > Under secret value, click on “retrieve secret value”. Paste the rds username you choose as the secret on GitHub.

· RDS_DB_PASSWORD — RDS_DB_NAME — Go to AWS console > Secrets Manager > select the secret we create before > Under secret value, click on “retrieve secret value”. Paste the rds password you choose as the secret on GitHub.

## VIII. Create the GitHub Action Workflow file

Navigate to “car_rental_dynamic_web_app” on VS Code

mkdir -p .github/workflows

cd .github/workflows

touch deploy_pipeline.yml

## IX. Create 3 GitHub Actions jobs

We will now create 3 GitHub Actions jobs:

Configure AWS credentials — This job will be responsible for configuring our IAM credentials, to verify our access to AWS and authorize our GitHub Actions job to create new resources in our AWS account

Build AWS infrastructure — This job will use terraform and ubuntu hosted runner to build our infrastructure in AWS. This job will apply our terraform code and create all the AWS resources we will use.

Create ECR repository — This job will create an repository in ECR, which we will use to store our docker image for this project.

Copy the content from the shared repo into your deploy_pipeline.yml

Comment lines 12–16 in order to not run (we will make them run afterwards)

Comment everything that is after line 174 by pressing Shift + Alt + A

git add.

git commit -m “added github actions jobs”

git push

Check the pipeline under the “Actions” tab on your GitHub repo

## X. Create a Self-Hosted Runner

For the next job in our pipeline, we will start a self-hosted ec2 runner in the private subnet. We will use this runner for two things in our pipeline:

First, we will use the runner to build our docker image and push the docker image to the amazon ECR repository we created previously.

Then, we will also use this runner to run our database migration with flyway.

The reason why we are using a self-hosted runner to complete these jobs is because launching an ec2 runner in our private subnet will allow the runner to easily access the resources in our private subnet.

In this project we want to migrate our data into the RDS database so, by launching our EC2 in the private subnet, it allows that EC2 runner to easily connect to the RDS in the private subnet and migrate our data into it with flyway.

Once we have successfully migrated our data, we will terminate the ec2 runner immediately.

If we use the GitHub hosted runner, there wouldn’t be a way for that runner to connect to our RDS instance in the private subnet because, as you know, any resources we put in the private subnet may require additional configuration to access resources outside our private subnet.

Steps to create this action: https://github.com/machulav/ec2-github-runner

To summary we will need to:

1) Create AWS access keys Pairs

2) Create a GitHub personal access token (we have it)

3) Prepare an EC2 image

4) Use the EC2 instance to create an AMI

5) Terminate the EC2 instance

Once we create our job to start our self-hosted runner, the job will use the AMI we created to start our self-hosted EC2 runner.

## XI. Create AWS access keys Pairs

We will now create the keys pair that we will use to SSH into our EC2 instance.

Go to AWS Management Console > EC2 > Key Pairs > Create Key Pair

![image](https://github.com/user-attachments/assets/f795729d-29f9-4b6c-a691-ff1322f86bd7)

## XII. Launch an EC2 instance in a public subnet

To create the AMI that we will use to start our self-hosted EC2 runner, the next thing we have to do is launch an EC2 instance in a public subnet.

Use the default VPC in our account to perform this action.

Go to AWS Management Console and create a new EC2 instance:

![image](https://github.com/user-attachments/assets/cd80349d-79a7-4316-8b7d-e269a0c1d7a7)
![image](https://github.com/user-attachments/assets/291d8de9-1bdb-440d-a810-e47cb5df44a9)
![image](https://github.com/user-attachments/assets/79f69b1a-ee4a-4dc6-b68b-1de39a7173db)

## XIII. SSH into an EC2 Instance

Now that we have launched our EC2 instance, the next thing we have to do is SSH into the EC2 instance.

Copy the Public IPv4 address of the EC2 instance:

![image](https://github.com/user-attachments/assets/a0c08745-e2b8-41d4-aafc-80aae663366b)

Open a terminal in the same directory where you have stored your Key Pair and run the following:

ssh -i my-ec2-key.pem ec2-user@<public ipv4 address from ec2 instance>

## XIV. Install Docker and Git on the EC2 Instance

Once you have SSH into your EC2 instance, the next thing we have to do is paste, copy, and run the bellow commands in your ec2 instance:

They will install docker, git and enable the docker service on our EC2 instance

sudo yum update -y && \

sudo yum install docker -y && \

sudo yum install git -y && \

sudo yum install libicu -y && \

sudo systemctl enable docker

## XV. Create an AMI and Terminate the EC2 Instance

Now that we have installed docker, git and enabled the docker service on our EC2 instance, the next thing we will do is use this EC2 instance to create an AMI.

This is done so our GitHub Actions job use that AMI to start our self-hosted runner.

![image](https://github.com/user-attachments/assets/1acbf0d4-c612-429f-aaba-f6a28f3dce2e)
![image](https://github.com/user-attachments/assets/0e485121-91dc-4db8-b424-842a2ad9f48b)

Wait for the status to become available and after that, confirm if a snapshot of the AMI was created on Elastic Block Store > Snapshots

Terminate your EC2 Instance

## XVI. Create a GitHub Actions Job to Start a Self-Hosted Runner

We will now create the GitHub Actions job that we will use to start the self-hosted runner in the private subnet.

Remove the comments on the “deploy_pipeline.yml” file until line 215

git add.

git commit -m “start ec2 runner”

git push

## XVII. Create a GitHub Actions Job to Build a Docker Image

This job will build the docker image for our application and push the image to the amazon ECR repository we created previously.

Before creating the job to build the Docker Image, we need to complete these steps first:

1) Set up a repository to store the application code and add the application code to the repository

2) Create a Docker file

3) Create the appserviceprovider.php file

1) Create a private repository to store the application codes

Go to GitHub and create a new repository.

I’ve named mine “application-codes-autorentify-project”

Clone the repo to your local computer

Download the required file from this link: https://github.com/Silas-cloudspace/application-codes-autorentify-project

Add it to the repository folder in your local machine

Open the repository “application-codes-autorentify-project” on VS code

Push it to your GitHub “application-codes-autorentify-project”

2) Create the Docker file

This is the file that our job will use to build the docker image for our application

Navigate to “car_rental_dynamic_web_app” in VS Code

Create a new file: touch Dockerfile

Copy the content from the shared repo and paste it into it

3) Create the appserviceprovider.php file

This will be used to redirect HTTP traffic to HTTPS

On “car_rental_dynamic_web_app” directory create a new file:

touch AppServiceProvider.php

Copy the content from the shared repo and paste it into it

## XVIII. Create a GitHub Actions Job to Build and Push a Docker Image to ECR

Go to your “deploy_pipeline.yml” file

Remove the comments on lines 12–15 and on lines 216–265

git add .

git commit -m “build docker image”

git push

## XIX. Create GitHub Actions Job to Export the Environment Variables into the S3 Bucket

This job will create in our pipeline will store all the build arguments we used to build the docker image in a file.

Once we have stored all the build arguments in a file, the job will copy the file into the S3 Bucket so that the ECS Fargate containers can reference the variables we stored in the file.

Go to your “deploy_pipeline.yml” file

Remove the comments from lines 266–300

git add .

git commit -m “create env file”

git push

Now, if you go to the S3 bucket we just created and click on the file, you can either press download or open to download the file. When you open the file after downloaded you can see all of your build arguments as key/value pair.

## XX. Create the SQL Folder and Add the SQL Script

We will now add the SQL script we want to migrate into our RDS database to our project folder.

Create a new folder in the “car_rental_dynamic_web_appcar_rental_dynamic_web_app” directory

mkdir sql

Download the SQL script here:

https://drive.google.com/file/d/15W32C77oo9g4klXgfQJ7gULC_p1MPI0R/view?usp=share_link

Move it to the SQL folder in VS Code

![image](https://github.com/user-attachments/assets/926f2948-680e-41fa-8d26-89c45a0e51fb)

## XXI. Create a GitHub Actions Job to Migrate Data into the RDS Database with Flyway

We will now use flyway to transfer the SQL data for our application into the RDS database in the next step in our pipeline.

This involves setting up flyway in our self-hosted runner and use it to move the data into RDS database.

Go to your “deploy_pipeline.yml” file

Remove the comments from lines 16, 301–339

This is the job we will use to migrate the data for our application into the RDS database using flyway

git add .

git commit -m “migrate data”

git push

## XXII. Terminate the Self-Hosted Runner in AWS Console

After we launched the self-hosted runner to build our docker image and migrate the data for our application int the RDS database, we will terminate the self-hosted runner.

Before we create the job to terminate the self-hosted runner, first we will terminate the self-hosted runner that is currently running in the management console.

We are removing this self-hosted runner because when our pipeline runs again, the “migrate data job” will try to download flyway in the runner and the job will fail because we already have flyway installed on it.

That is why we are terminating it for now. But a new self-hosted runner will be created when our pipeline runs and the next job, we will create will terminate the self-hosted runner once it has completed the task it was created for.

Go to EC2 in the management console and delete(terminate) your ec2-github-runner.

## XXIII. Create a GitHub Actions job to Stop the Self-Hosted EC2 Runner

Go to your “deploy_pipeline.yml” file

Remove the comments from lines 341–360

git add .

git commit -m “stop runner”

git push

## XXIV. Create a GitHub Actions Job to Create a New Task Definition Revision

We will now create a new job to update the task definition for the ECS service hosted in our application with the new image we pushed into amazon ECR.

Go to your “deploy_pipeline.yml” file

Remove the comments from lines 363–401

git add .

git commit -m “created td revision”

git push

## XXV. Create a GitHub Actions Job to Restart the ECS Fargate Service

We will now create the final job in our pipeline that will restart the ECS service and forces it to use the latest task definition revision we created previously.

Go to your “deploy_pipeline.yml” file

Remove the comments from lines 404–433

git add .

git commit -m “restart ECS service”

git push

Go to the Web browser and paste your domain name. In my case: “cloudspace-consulting.com”








