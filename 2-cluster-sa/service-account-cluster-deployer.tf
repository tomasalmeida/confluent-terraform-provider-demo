resource "confluent_service_account" "sa-cluster-stage-deployer" {
  display_name = "sa-cluster-stage-deployer"
  description  = "Service account to deploy resources to cluster stage"
}

resource "confluent_api_key" "kafka-api-key-sa-cluster-stage-deployer" {
  display_name = "api-key-sa-cluster-stage-deployer"
  description  = "Kafka API Key that is owned by 'sa-cluster-stage-deployer' service account"
  owner {
    id          = confluent_service_account.sa-cluster-stage-deployer.id
    api_version = confluent_service_account.sa-cluster-stage-deployer.api_version
    kind        = confluent_service_account.sa-cluster-stage-deployer.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.cluster-stage-aws.id
    api_version = confluent_kafka_cluster.cluster-stage-aws.api_version
    kind        = confluent_kafka_cluster.cluster-stage-aws.kind

    environment {
      id = data.confluent_environment.env-stage.id
    }
  }
}

resource "confluent_api_key" "cloud-api-key-sa-cluster-stage-deployer" {
  display_name = "api-key-sa-cluster-stage-deployer"
  description  = "Cloud API Key that is owned by 'sa-cluster-stage-deployer' service account"
  owner {
    id          = confluent_service_account.sa-cluster-stage-deployer.id
    api_version = confluent_service_account.sa-cluster-stage-deployer.api_version
    kind        = confluent_service_account.sa-cluster-stage-deployer.kind
  }
}

resource "confluent_role_binding" "app-manager-source-cluster-admin" {
  principal   = "User:${confluent_service_account.sa-cluster-stage-deployer.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.cluster-stage-aws.rbac_crn
}


resource "local_file" "service-accounts-file" {
  content  = <<-EOT
  Service account cluster stage deployer:
    - ID: ${confluent_service_account.sa-cluster-stage-deployer.id}
    - Kafka API Key:    "${confluent_api_key.kafka-api-key-sa-cluster-stage-deployer.id}"
    - Kafka API Secret: "${confluent_api_key.kafka-api-key-sa-cluster-stage-deployer.secret}"
    - Cloud API Key:    "${confluent_api_key.cloud-api-key-sa-cluster-stage-deployer.id}"
    - Cloud API Secret: "${confluent_api_key.cloud-api-key-sa-cluster-stage-deployer.secret}"
  EOT

  filename = "outputs/service-account-cluster-stage-deployer.txt"
}