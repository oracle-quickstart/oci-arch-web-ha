# This example file shows how to create a group and add a user to it.

resource "oci_identity_group" "web-group" {
  name           = "web-app-group"
  description    = "group created by terraform"
  compartment_id = "${var.tenancy_ocid}"
}

resource "oci_identity_user_group_membership" "user-group-mem1" {
  compartment_id = "${var.tenancy_ocid}"
  user_id        = "${var.user_id}"
  group_id       = "${oci_identity_group.web-group.id}"
}

data "oci_identity_groups" "groups1" {
  compartment_id = "${oci_identity_group.web-group.compartment_id}"

  filter {
    name   = "name"
    values = ["web-app-group"]
  }
}