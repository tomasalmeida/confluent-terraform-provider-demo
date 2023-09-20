variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)"
  type        = string
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}

variable "confluent_kafka_api_key" {
  description = "Kafka API Key"
  type        = string
}

variable "confluent_kafka_api_secret" {
  description = "Kafka API Secret"
  type        = string
  sensitive   = true
}
