# Output variables from created vcn

output "subnet1_ocid" {
  value = "${oci_core_subnet.subnet_1.id}"
}

output "subnet2_ocid" {
  value = "${oci_core_subnet.subnet_2.id}"
}

output "subnet3_ocid" {
  value = "${oci_core_subnet.subnet_3.id}"
}