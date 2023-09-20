resource "confluent_service_account" "sa-app-c" {
  display_name = "sa-app-c"
  description  = "Service account to be used by app C"
}

resource "local_file" "service-accounts-file-c" {
  content  = <<-EOT
  Service account app C:
    - ID: ${confluent_service_account.sa-app-c.id}
  EOT

  filename = "outputs/service-account-app-c.txt"
}