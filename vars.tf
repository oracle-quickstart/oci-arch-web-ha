# Variables Exported from env.sh
variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "image_ocid" {}
variable "private_key_path" {}
variable "region" {}
variable "ssh_public_key" {}
variable "instance_shape" {}
variable "ssh_authorized_private_key" {}

# Specify any Default Value's here

variable "availability_domain" {
  default="3"
}

variable "instance_user" {
  default="opc"
}

variable "compartment_name" {
  default = "Compartment name to work-on"
}

/*
we are specifying dokcer username and password to deploy a sample app. 
However specify the username and password of your docker hub where you have your docker image stored.
*/

variable "docker_username" {
  default = "testuser2000"
}

variable "docker_password" {
  default = "testpassword123!"
}



