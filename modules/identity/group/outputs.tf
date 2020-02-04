# Output variables from created group

output "groups" {
  value = "${data.oci_identity_groups.groups1.groups}"
}

output "group_name" {
  value = "${oci_identity_group.web-group.name}"
}