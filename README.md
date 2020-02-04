# Web-App
A deployable solution for web application on highly available infrastructure in Oracle Cloud Infrastructure.


## Pre-Requisites

- You need an Oracle cloud account. Sign up here to create a free trial on OCI - [OCI free trial link](https://www.oracle.com/cloud/free/)

- Terraform — use the link to download terraform. Choose the operating systems you plan to work on - [Terraform download](https://www.terraform.io/downloads.html)

- Follow the steps in the video link to install terrafor - [Install Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)

(Note that, for linux and mac steps are similar except the file to be edited shown in the video link is — profile for linux and bash_profile for mac)

Verify terraform is installed successfully using below command.

`terraform --version`

## Deploying the solution

### Step 1: Spinning up the infrastructure

I have used Terraform to spin up the infrastructure.

Go ahead and download the zip folder `web-app.zip` contained in this repository. Unzip it on your machine and open in your favorite editor. (Vim, Sublime, VSCode, Atom etc.)

In the opened editor, edit the file `env.sh` to fill in the details specific to your account on OCI.

In `vars.tf` file, go ahead and provide the compartment name based on the compartment you have created or plan to create. If you are using `root` compartment, please provide the same name in the file.

#### *** Optional Step ***

Also if you want to use your own docker image stored in docker hub, edit the file `vars.tf` to enter docker username and password. If you plan on using the one used for this implementation then you can ignore and keep it as it is. 

When all the variables set, you are ready to run the terraform script.

### Step 2: Running the script

On the terminal or command line, cd into the downloaded folder `web-app`

`cd web-app`

Let’s export all the variables from `env.sh` into current directory.

`source env.sh`

Initialize terraform using below command

`terraform init`

Plan the terraform using below command

`terraform plan`

Apply Terraform using below command

`terraform apply`

It will prompt ***Enter a value***. Type ***yes***

This will start creating the resources on OCI and might take ~1 hour to finish the job.

Once, it completes you should be able to login to OCI and see all the resources provisioned as expected in terraform.

## Testing

Go to created resource load balancer and grab it’s public IP.

Open up your favorite browser (Chrome, Firefox etc.) and type `http://<public_ip>/api/`

You should be able to see a web page displayed that fetches the data from Oracle database.

Now, to check if its highly available, go ahead and delete one of the compute instances. Since we have a load balancer deployed, we should still be able to get the response from another running compute instance.

Let’s test it again on the browser. On the browser type `http://<public_ip>/api/`

You should still be able to get a response displaying the same web page you saw earlier. This suggest that our app is highly available even in case of the failure of the other instance. If you were to delete both the instances you should get an error on browser which means our app is no longer available.

Finally, if you like to destroy all the created resources, run below command.

`terraform destroy`

It will prompt ***Enter a value***. Type ***yes***
