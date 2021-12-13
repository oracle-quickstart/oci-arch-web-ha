## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# This Terraform script provisions a compute instance

data "template_file" "key_script" {
  template = file("${path.module}/scripts/sshkey.tpl")
  vars = {
    ssh_public_key = tls_private_key.public_private_key_pair.public_key_openssh
  }
}

data "template_cloudinit_config" "cloud_init" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "ainit.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.key_script.rendered
  }
}

# Create Compute Instance

resource "oci_core_instance" "compute_instance1" {
  availability_domain = local.availability_domain_name
  compartment_id      = var.compartment_ocid
  display_name        = "Web-Server-1"
  shape               = var.instance_shape
  lifecycle {
    ignore_changes = [defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"]]
  }

  dynamic "shape_config" {
    for_each = local.is_flexible_node_shape ? [1] : []
    content {
      memory_in_gbs = var.instance_flex_shape_memory
      ocpus         = var.instance_flex_shape_ocpus
    }
  }

  fault_domain = "FAULT-DOMAIN-1"

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.InstanceImageOCID.images[0].id
    boot_volume_size_in_gbs = "50"
  }

  create_vnic_details {
    subnet_id = oci_core_subnet.subnet_2.id
    nsg_ids   = [oci_core_network_security_group.WebSecurityGroup.id, oci_core_network_security_group.SSHSecurityGroup.id]
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = data.template_cloudinit_config.cloud_init.rendered
  }

  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

  timeouts {
    create = "60m"
  }
}

resource "oci_core_instance" "compute_instance2" {
  availability_domain = local.availability_domain_name
  compartment_id      = var.compartment_ocid
  display_name        = "Web-Server-2"
  shape               = var.instance_shape
  lifecycle {
    ignore_changes = [defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"]]
  }

  dynamic "shape_config" {
    for_each = local.is_flexible_node_shape ? [1] : []
    content {
      memory_in_gbs = var.instance_flex_shape_memory
      ocpus         = var.instance_flex_shape_ocpus
    }
  }

  fault_domain = "FAULT-DOMAIN-2"

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.InstanceImageOCID.images[0].id
    boot_volume_size_in_gbs = "50"
  }

  create_vnic_details {
    subnet_id = oci_core_subnet.subnet_2.id
    nsg_ids   = [oci_core_network_security_group.WebSecurityGroup.id, oci_core_network_security_group.SSHSecurityGroup.id]
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = data.template_cloudinit_config.cloud_init.rendered
  }

  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

  timeouts {
    create = "60m"
  }
}

