## Copyright (c) 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_nat_gateway" "nat_gw" {
  compartment_id = var.compartment_ocid
  display_name   = "nat_gateway"
  vcn_id         = oci_core_virtual_network.vcn.id
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  lifecycle {
    ignore_changes = [defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"]]
  }
}
