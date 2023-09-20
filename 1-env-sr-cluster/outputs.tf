output "resources-ids" {
  value = <<-EOT
  Environment ID:   ${confluent_environment.env-stage.id}
  Schema Registry ID: ${confluent_schema_registry_cluster.sr-essentials.id}
  EOT
  sensitive = false
}
