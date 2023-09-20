output "resources-ids" {
  value = <<-EOT
  Environment ID:   ${data.confluent_environment.env-stage.id}
  Kafka Cluster ID: ${confluent_kafka_cluster.cluster-stage-aws.id}
  EOT

  sensitive = false
}
