# Output variables from created user

output "test-user" {
  value = "${data.oci_identity_users.test-user.users}"
}

output "user_id" {
  value = "${oci_identity_user.test-user.id}"
}

output "user-password" {
  sensitive = false
  value     = "${oci_identity_ui_password.password1.password}"
}

output "user-api-key" {
  value = "${oci_identity_api_key.api-key1.key_value}"
}

output "auth-token" {
  value = "${oci_identity_auth_token.auth-token1.token}"
}

output "customer-secret-key" {
  value = [
    "${oci_identity_customer_secret_key.customer-secret-key1.key}",
    "${data.oci_identity_customer_secret_keys.customer-secret-keys1.customer_secret_keys}",
  ]
}