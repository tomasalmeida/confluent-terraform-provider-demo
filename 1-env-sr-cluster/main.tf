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

resource "confluent_environment" "env-stage" {
  display_name = "stage"

  lifecycle {
    prevent_destroy = false
  }
}

# Stream Governance and Kafka clusters can be in different regions as well as different cloud providers,
# but you should to place both in the same cloud and region to restrict the fault isolation boundary.
data "confluent_schema_registry_region" "srr-essentials" {
  cloud   = "AWS"
  region  = "us-east-2"
  package = "ESSENTIALS"
}

resource "confluent_schema_registry_cluster" "sr-essentials" {
  package = data.confluent_schema_registry_region.srr-essentials.package

  environment {
    id = confluent_environment.env-stage.id
  }

  region {
    # See https://docs.confluent.io/cloud/current/stream-governance/packages.html#stream-governance-regions
    id = data.confluent_schema_registry_region.srr-essentials.id
  }

  lifecycle {
#    prevent_destroy = false   
    prevent_destroy = false
  }
}

resource "local_file" "env-file" {
  content  = <<-EOT
  Environment ID:   ${confluent_environment.env-stage.id}
  Schema Registry ID: ${confluent_schema_registry_cluster.sr-essentials.id}
  EOT

  filename = "outputs/env.txt"
}