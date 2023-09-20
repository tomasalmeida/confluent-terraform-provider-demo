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

data "confluent_kafka_cluster" "cluster-stage-aws" {
  # id = "lkc-cde567"
  display_name = "cluster-stage-aws"
  environment {
    id = "env-abc123"
  }
}

data "confluent_service_account" "sa-app-a" {
#  id = "sa-jz6nnq"
  display_name = "sa-app-a"
}

data "confluent_service_account" "sa-app-b" {
  display_name = "sa-app-b"
}

data "confluent_service_account" "sa-app-c" {
  display_name = "sa-app-c"
}