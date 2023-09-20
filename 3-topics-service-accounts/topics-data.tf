resource "confluent_kafka_topic" "data-orders" {
  kafka_cluster {
    id = data.confluent_kafka_cluster.cluster-stage-aws.id
  }
  topic_name    = "data-orders"
  rest_endpoint = data.confluent_kafka_cluster.cluster-stage-aws.rest_endpoint
  credentials {
    key    = var.confluent_kafka_api_key
    secret = var.confluent_kafka_api_secret
  }
}


resource "confluent_role_binding" "rbac-app-a-topic-data-orders" {
  principal   = "User:${data.confluent_service_account.sa-app-a.id}"
  role_name   = "DeveloperManage"
  crn_pattern = "${data.confluent_kafka_cluster.cluster-stage-aws.rbac_crn}/kafka=${data.confluent_kafka_cluster.cluster-stage-aws.id}/topic=${confluent_kafka_topic.data-orders.topic_name}"
}

#resource "confluent_role_binding" "rbac-app-b-topic-data-orders" {
#  principal   = "User:${data.confluent_service_account.sa-app-b.id}"
#  role_name   = "DeveloperWrite"
#  crn_pattern = "${data.confluent_kafka_cluster.cluster-stage-aws.rbac_crn}/kafka=${data.confluent_kafka_cluster.cluster-stage-aws.id}/topic=${confluent_kafka_topic.data-orders.topic_name}"
#}
#
#resource "confluent_role_binding" "rbac-app-c-topic-data-orders" {
#  principal   = "User:${data.confluent_service_account.sa-app-c.id}"
#  role_name   = "DeveloperRead"
#  crn_pattern = "${data.confluent_kafka_cluster.cluster-stage-aws.rbac_crn}/kafka=${data.confluent_kafka_cluster.cluster-stage-aws.id}/topic=${confluent_kafka_topic.data-orders.topic_name}"
#}