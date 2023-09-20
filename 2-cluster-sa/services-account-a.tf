resource "confluent_service_account" "sa-app-a" {
  display_name = "sa-app-a"
  description  = "Service account to be used by app A"
}


resource "confluent_api_key" "api-key-sa-app-a" {
  display_name = "api-key-sa-app-a"
  description  = "Kafka API Key that is owned by 'sa-app-a' service account"
  owner {
    id          = confluent_service_account.sa-app-a.id
    api_version = confluent_service_account.sa-app-a.api_version
    kind        = confluent_service_account.sa-app-a.kind
  }
}


resource "local_file" "service-accounts-file-a" {
  content  = <<-EOT
  Service account app A:
    - ID: ${confluent_service_account.sa-app-a.id}
    - Kafka API Key:    "${confluent_api_key.api-key-sa-app-a.id}"
    - Kafka API Secret: "${confluent_api_key.api-key-sa-app-a.secret}"
  EOT

  filename = "outputs/service-account-app-a.txt"
}