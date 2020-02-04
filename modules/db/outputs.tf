# Output the public IP of the instance
output "db_node_public_ip1" {
   value = "${data.oci_core_vnic.db_node_vnic1.public_ip_address}"
}
