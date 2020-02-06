/*
*  calling the different modules from this main file
*/

module "user"{
    source = "./modules/identity/user"
    tenancy_ocid = "${var.tenancy_ocid}"
}

module "group"{
    source = "./modules/identity/group"
    tenancy_ocid = "${var.tenancy_ocid}"
    user_id = "${module.user.user_id}"
}

module "policy"{
    source = "./modules/identity/policy"
    compartment_name = "${var.compartment_name}"
    group_name = "${module.group.group_name}"
    compartment_ocid = "${var.compartment_ocid}"
}

module "vcn"{
  source = "./modules/vcn"
  tenancy_ocid = "${var.tenancy_ocid}"
  compartment_ocid = "${var.compartment_ocid}"
}

module "database"{
    source = "./modules/db"
    tenancy_ocid = "${var.tenancy_ocid}"
    compartment_ocid = "${var.compartment_ocid}"
    availability_domain = "${var.availability_domain}"
    ssh_public_key = "${var.ssh_public_key}"
    ssh_private_key   = "${var.ssh_authorized_private_key}"
    subnet = "${module.vcn.subnet3_ocid}"
}

module "compute"{
    source = "./modules/compute"
    tenancy_ocid = "${var.tenancy_ocid}"
    compartment_ocid = "${var.compartment_ocid}"
    availability_domain = "${var.availability_domain}"
    image_ocid = "${var.image_ocid}"
    instance_shape = "${var.instance_shape}"
    ssh_public_key = "${var.ssh_public_key}"
    subnet1_ocid = "${module.vcn.subnet2_ocid}"
    subnet2_ocid = "${module.vcn.subnet2_ocid}"
}

module "lb"{
    source = "./modules/load_balancer"
    tenancy_ocid = "${var.tenancy_ocid}"
    compartment_ocid = "${var.compartment_ocid}"
    private_ip1 = "${module.compute.private_ip1}"
    private_ip2 = "${module.compute.private_ip2}"
    subnet_ad1 = "${module.vcn.subnet1_ocid}"
}

module "remote-exec"{
    source = "./modules/remote"
    ssh_private_key   = "${var.ssh_authorized_private_key}"
    public-ip1        = "${module.compute.public_ip1}"
    public-ip2        = "${module.compute.public_ip2}"
    instance_user     = "${var.instance_user}"
    db_node_public_ip1 = "${module.database.db_node_public_ip1}"
    docker_username = "${var.docker_username}"
    docker_password = "${var.docker_password}"
}