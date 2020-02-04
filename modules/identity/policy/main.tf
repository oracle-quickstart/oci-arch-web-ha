/*
 * This example file shows how to define policies for the compartment
 */

resource "oci_identity_policy" "policy1" {
  name           = "tf-example-policy"
  description    = "policy created by terraform"
  compartment_id = "${var.compartment_ocid}"

  statements = ["Allow group ${var.group_name} to manage all-resources in compartment ${var.compartment_name}"]
}