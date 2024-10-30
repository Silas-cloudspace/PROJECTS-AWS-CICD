# PORTFOLIO WEBSITE HOSTED ON AWS S3 USING TERRAFORM AND GITHUB ACTIONS

![image](https://github.com/user-attachments/assets/3f639254-d1e1-4721-8c3d-3af8fcb22b4c)

This project requires that you already have a domain name.

## I. Create and clone a git repository

You can name it “portfolio-website” (you can also choose a different name).

Add a README file

Add a .gitignore file to it and select Terraform

## II. Set up your environment

Go to VScode

Create a folder named “website” under the directory “portfolio-website”.

Go to the following website: https://downgit.evecalm.com/#/home

Paste the GitHub directory link from where you will download the files to add to the folder yu just create. In your case it’s from: https://github.com/Silas-cloudspace/PROJECTS-AWS-CICD/tree/main/portfolio_website/website

Unzip the file and add the files into the folder “website” in your machine.

## III. Create essential terraform files and folders

In VS Code go to “portfolio-website” directory and write the following commands:

mkdir terraform

cd terraform

mkdir remote_backend

touch main.tf

## IV. Push changes to the Github repository

In VS Code go to “portfolio-website” directory and write the following commands:

git add .

git commit -m “added terraform and website files”

git push

## V. Create a remote backend module

Navigate to this directory: cd remote_backend

Create the following file inside:

touch backend.tf

Define the necessary resources to be added to this file

Copy from: https://github.com/Silas-cloudspace/PROJECTS-AWS-CICD/blob/main/portfolio_website/terraform/remote_backend/backend.tf

Remember to change or add what needs to be changed

## VI. Initiate the terraform configuration and deploy remote backend resources

terraform init

terraform apply

## VII. Configure a remote backend for terraform state

Navigate to terraform directory: cd ..

touch backend.tf

Copy the following code into it: https://github.com/Silas-cloudspace/PROJECTS-AWS-CICD/blob/main/portfolio_website/terraform/backend.tf

terraform init

terraform apply

## VIII. Create a Certificate

Create a new file on the “terraform directory”

• touch acm.tf

• Copy and paste into it: https://github.com/Silas-cloudspace/PROJECTS-AWS-CICD/blob/main/portfolio_website/terraform/acm.tf

Run:

• terraform init

• terraform apply

## IX. Create the Github workflow directory and workflow file

On the main directory (portfolio-website) create the following:

• mkdir -p .github/workflows

• cd .github/workflows

• touch deploy-website.yaml

## X. Configure GitHub Actions Secrets

Go to your GitHub repository

Click on settings

Navigate to “Secrets and variables”

Choose “actions”

Click on “New repository secret”

Add 2 secrets:

• One for your AWS access key ID

• Another for your AWS secret access key

## XI. Write the GitHub Actions workflow code

You can get it here: https://github.com/Silas-cloudspace/PROJECTS-AWS-CICD/blob/main/portfolio_website/workflows/deploy-website.yaml

## XII. Test the workflow

Navigate to root directory (portfolio-website)

cd ../..

git add .

git commit -m “Implemented deployment workflow”

git push

Go to your GitHub repository and click on the “Actions” tab

Check out each step execution

## XIII. Setting up Route53

Navigate to your “terraform” directory

touch route53.tf

copy and paste the following code into it: https://github.com/Silas-cloudspace/PROJECTS-AWS-CICD/blob/main/portfolio_website/terraform/route53.tf

## XIV. Commit and push changes into your GitHub repository

Go to your root directory (portfolio-website)

git add .

git commit -m “Implemented Route53”

git push

Check the workflow on GitHub Actions under the tab “Actions” in your repository.

## XV. Create the S3 bucket for web hosting

Create a new file on the “terraform directory”

• touch s3.tf

• Copy and paste into it: https://github.com/Silas-cloudspace/PROJECTS-AWS-CICD/blob/main/portfolio_website/terraform/s3.tf

## XVI. Initialize Terraform and push s3 website to GitHub

Navigate to “terraform” directory

Do “terraform init” to check if everything is ok with our code

git add .

git commit -m “Implemented s3 bucket for website hosting”

git push

Check it out on GitHub under “Actions” tab.

## XVII. Sync and visualize your portfolio website

Navigate to “portfolio-website” directory in vs code

Run: aws s3 sync ./website s3://website-bucket-st

In the AWS console navigate into S3 buckets and select the bucket we created

Click on the “properties” tab

Scroll down and copy the “Bucket website endpoint” link

Paste it on a web browser

*Remember that you can configure name, image and links in the “index.html” file that is inside the “website” folder

## XVIII. Configure CloudFront

Navigate to terraform directory on VS code
Run: touch cloudfront.tf

Copy and paste the following code into it: https://github.com/Silas-cloudspace/PROJECTS-AWS-CICD/blob/main/portfolio_website/terraform/cloudfront.tf

## XIX. Commit and push changes

On the “terraform” directory run:

• terraform init (just to check if the configuration is correct)

• git add .

• git commit -m “Implemented cloudfront”

• git push

• Check it out on the “actions” tab

## XX. Implementing Invalidate CloudFront cache

Go to “.github/workflows” on VS code

Add the following files into it:

https://github.com/Silas-cloudspace/PROJECTS-AWS-CICD/blob/main/portfolio_website/workflows/sync_s3.yaml

https://github.com/Silas-cloudspace/PROJECTS-AWS-CICD/blob/main/portfolio_website/workflows/invalidate-cloudfront.yml

Go to VS code > Settings > Secrets and variables > Actions > New repository secret

Name it: DISTRIBUTION

Paste your CloudFront distribution ID as secret.

## XXI. Commit and push new changes

Navigate to portfolio-website

git add .

git commit -m “Implemented invalidate cloudfront cache github action to workflow”

git push

Check out the workflow on github

## XXII. Check the website once again

In the AWS console navigate into S3 buckets and select the bucket we created.

Click on the “properties” tab

Scroll down and copy the “Bucket website endpoint” link

Paste it on a web browser

*Remember that you can configure name, image and links in the “index.html” file that is inside the “website” folder
