terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.52.0"
    }
  }
}

provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}


# cloud-importer: Export Cloud resources (for example, Service Accounts, Environments)
# -> https://github.com/confluentinc/terraform-provider-confluent/blob/master/examples/configurations/cloud-importer/main.tf
# kafka-importer: Export Kafka resources (for example, ACLs, Topics)
# -> https://github.com/confluentinc/terraform-provider-confluent/blob/master/examples/configurations/kafka-importer/main.tf

resource "confluent_tf_importer" "all-importer" {
  # resources = ["confluent_service_account", "confluent_environment"]
  output_path = "."
}