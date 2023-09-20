resource "confluent_service_account" "sa-app-b" {
  display_name = "sa-app-b"
  description  = "Service account to be used by app B"
}

resource "local_file" "service-accounts-file-b" {
  content  = <<-EOT
  Service account app B:
    - ID: ${confluent_service_account.sa-app-b.id}
  EOT

  filename = "outputs/service-account-app-b.txt"
}