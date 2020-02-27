# This Terraform script provisions a compute instance

# Create Compute Instance

resource "oci_core_instance" "compute_instance1" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 2]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "Web-Server-1"
  shape               = var.instance_shape
  subnet_id           = oci_core_subnet.subnet_2.id
  fault_domain        = "FAULT-DOMAIN-1"

source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.InstanceImageOCID.images[0].id
    boot_volume_size_in_gbs = "50"
  }

  metadata = {
    ssh_authorized_keys = chomp(file(var.ssh_public_key))
  }

  timeouts {
    create = "60m"
  }
}

resource "oci_core_instance" "compute_instance2" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 2]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "Web-Server-2"
  shape               = var.instance_shape
  subnet_id           = oci_core_subnet.subnet_2.id
  fault_domain        = "FAULT-DOMAIN-2"

source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.InstanceImageOCID.images[0].id
    boot_volume_size_in_gbs = "50"
  }

  metadata = {
    ssh_authorized_keys = chomp(file(var.ssh_public_key))
  }

  timeouts {
    create = "60m"
  }
}

