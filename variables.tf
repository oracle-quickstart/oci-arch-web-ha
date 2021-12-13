## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Variables
variable "tenancy_ocid" {}
variable "compartment_ocid" {
  default = ""
}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "ATP_password" {}

variable "availability_domain_number" {
  default = 0
}

variable "availability_domain_name" {
  default = ""
}

variable "release" {
  description = "Reference Architecture Release (OCI Architecture Center)"
  default     = "1.3"
}

variable "ssh_public_key" {
  default = ""
}
variable "ssh_public_key_path" {
  default = ""
}

variable "lb_shape" {
  default = "flexible"
}

variable "flex_lb_min_shape" {
  default = "10"
}

variable "flex_lb_max_shape" {
  default = "100"
}

# OS Images
variable "instance_os" {
  description = "Operating system for compute instances"
  default     = "Oracle Linux"
}

variable "linux_os_version" {
  description = "Operating system version for all Linux instances"
  default     = "7.9"
}

variable "instance_shape" {
  default = "VM.Standard.E3.Flex"
}

variable "instance_flex_shape_ocpus" {
  default = 1
}

variable "instance_flex_shape_memory" {
  default = 10
}

variable "ATP_private_endpoint" {
  default = true
}

variable "ATP_database_cpu_core_count" {
  default = 1
}

variable "ATP_database_data_storage_size_in_tbs" {
  default = 1
}

variable "ATP_database_db_name" {
  default = "WEBHAATP"
}

variable "ATP_database_db_version" {
  default = "19c"
}

variable "ATP_database_defined_tags_value" {
  default = "value"
}

variable "ATP_database_display_name" {
  default = "WEBHAATP"
}

variable "ATP_database_freeform_tags" {
  default = {
    "Owner" = "WEBHAATP"
  }
}

variable "ATP_database_license_model" {
  default = "LICENSE_INCLUDED"
}

variable "ATP_tde_wallet_zip_file" {
  default = "tde_wallet_WEBHAATP.zip"
}

variable "ATP_private_endpoint_label" {
  default = "ATPPrivateEndpoint"
}

variable "ATP_data_guard_enabled" {
  default = false
}

locals {
  # Dictionary Locals
  compute_flexible_shapes = [
    "VM.Standard.E3.Flex",
    "VM.Standard.E4.Flex",
    "VM.Optimized3.Flex",
    "VM.Standard.A1.Flex"
  ]
  # Checks if is using Flexible Compute Shapes
  is_flexible_node_shape = contains(local.compute_flexible_shapes, var.instance_shape)

  availability_domain_name = var.availability_domain_name == "" ? lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain_number], "name") : var.availability_domain_name
}
