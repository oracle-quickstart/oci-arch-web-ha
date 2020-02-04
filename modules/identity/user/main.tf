/*
 * This example file shows how to create an user, add an api key, define auth tokens and customer secret keys.
 * API key -> for accessing OCI API's ( PEM format and paste the public key under user)
 * SSH key -> to access Instance ( create key pair and upload the public key during instance creation time)
 * Auth token -> allow third party api's to access OCI resources
 */

# Creating a user

resource "oci_identity_user" "test-user" {
  name           = "web-user"
  description    = "User created by terraform for web app access"
  compartment_id = "${var.tenancy_ocid}"
}

# Information about the user

data "oci_identity_users" "test-user" {
  compartment_id = "${oci_identity_user.test-user.compartment_id}"

  filter {
    name   = "name"
    values = ["web-user"]
  }
}

# password for the user

resource "oci_identity_ui_password" "password1" {
  user_id = "${oci_identity_user.test-user.id}"
}

# api key for the user

resource "oci_identity_api_key" "api-key1" {
  user_id = "${oci_identity_user.test-user.id}"

  key_value = <<EOF
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA7BNXFPcjQZI2LHgwjoKv
nhEOqgt6M935/26Sny+M9ENqG0vVq+hzLCGkG0OiZnv1TjjiQWZ/at3YRrMDE/vr
mK3sRvd529H3CjTpSaGG1Lrpi9dbwiSiVZVxLHyRg6EInB2P0sv4GY5q9EaXl0Ur
tqMJVLcmVDc+u+pdO9SKkMQM5d+OauWweTRKTHg02ctBz6FNcLbkB1ckGVihCl0/
m0lQCPPFs+PC5D3XEj12K11ll7avDBMaCNMd4/sxsxUXalhkx2w4e99X2m33t0jC
2croXlO7G9HPOtrgs1az86EYS9UrWSyX99Dm6ScQfous3zi4okf7VAdMPNmPE9ZG
mwIDAQAB
-----END PUBLIC KEY-----
EOF
}

# SwiftPassword has been deprecated. Use AuthToken instead.

resource "oci_identity_auth_token" "auth-token1" {
  #Required
  user_id     = "${oci_identity_user.test-user.id}"
  description = "user auth token created by terraform"
}

resource "oci_identity_customer_secret_key" "customer-secret-key1" {
  user_id      = "${oci_identity_user.test-user.id}"
  display_name = "WebApp-example-customer-secret-key"
}

data "oci_identity_customer_secret_keys" "customer-secret-keys1" {
  user_id = "${oci_identity_customer_secret_key.customer-secret-key1.user_id}"
}