# This Terraform script provisions a compute instance

# Create Compute Instance

resource "oci_core_instance" "compute_instance1" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 2],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "Web-Server-1"
  image = "${var.image_ocid}"
  shape = "${var.instance_shape}"
  subnet_id = "${var.subnet1_ocid}"
  fault_domain        = "FAULT-DOMAIN-1"

  metadata = {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }

  timeouts {
    create = "60m"
  }
}

resource "oci_core_instance" "compute_instance2" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 2],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "Web-Server-2"
  image = "${var.image_ocid}"
  shape = "${var.instance_shape}"
  subnet_id = "${var.subnet2_ocid}"
  fault_domain        = "FAULT-DOMAIN-2"

  metadata = {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }

  timeouts {
    create = "60m"
  }
}