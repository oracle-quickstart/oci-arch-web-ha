output "LoadBalancer_public_IP" {
  value = [oci_load_balancer.lb1.ip_addresses]
}