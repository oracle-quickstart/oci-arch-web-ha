# Output variables from created compute instance

output "instance_ocid1" {
  value = "${oci_core_instance.compute_instance1.id}"
}

output "instance_ocid2" {
  value = "${oci_core_instance.compute_instance2.id}"
}

output "public_ip1" {
  value = "${oci_core_instance.compute_instance1.public_ip}"
}

output "public_ip2" {
  value = "${oci_core_instance.compute_instance2.public_ip}"
}

output "private_ip1" {
  value = "${oci_core_instance.compute_instance1.private_ip}"
}

output "private_ip2" {
  value = "${oci_core_instance.compute_instance2.private_ip}"
}