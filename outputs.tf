output "loadbalancer_public_pl" {
  value = [oci_load_balancer.lb1.ip_addresses]
}

output "generated_ssh_private_key" {
  value = tls_private_key.public_private_key_pair.private_key_pem
}