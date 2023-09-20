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

data "confluent_environment" "env-stage" {
#  id = "env-abc123"
  display_name = "stage"
}

# Update the config to use a cloud provider and region of your choice.
# https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/confluent_kafka_cluster
resource "confluent_kafka_cluster" "cluster-stage-aws" {
  display_name = "cluster-stage-aws"
  availability = "SINGLE_ZONE"
  cloud        = "AWS"
  region       = "us-east-2"
#  basic{}
  standard{}
  #dedicated {
  #  cku = 1
  #}
  environment {
    id = data.confluent_environment.env-stage.id
  }
}

resource "local_file" "cluster-file" {
  content  = <<-EOT
  Environment ID:   ${data.confluent_environment.env-stage.id}
  Kafka Cluster ID: ${confluent_kafka_cluster.cluster-stage-aws.id}
  Kafka Cluster endpoint: ${confluent_kafka_cluster.cluster-stage-aws.rest_endpoint}
  EOT

  filename = "outputs/cluster.txt"
}