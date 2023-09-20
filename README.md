# Demo: different pipelines with different permissions to create permanent resources (cluster/env's/accounts) and volatile ones (topics/role bindings/etc)

## 0 - create the credentials and login

    confluent login --prompt
    confluent iam service-account create env-deployer --description "env deployer service account"
    +-------------+------------------------------+
    | ID          | sa-123acb                    |
    | Name        | env-deployer                 |
    | Description | env deployer service account |
    +-------------+------------------------------+
    
    confluent api-key create --service-account sa-123acb --resource cloud
    +------------+------------------------------------------------------------------+
    | API Key    | ENVDEPLOYERAPIKEY                                                |
    | API Secret | ENVDEPLOYERAPISECRET                                             |
    +------------+------------------------------------------------------------------+
    
    confluent iam rbac role-binding create --principal "User:sa-123acb" --role "OrganizationAdmin" 
    +-----------+-------------------+
    | Principal | User:sa-123acb    |   
    | Role      | OrganizationAdmin |
    +-----------+-------------------+

## 1 - Create env + Schema Registry

To create the environment and Schema registry, OrgAdmin permission is needed, so the key above is used here.

    export TF_VAR_confluent_cloud_api_key="ENVDEPLOYERAPIKEY"
    export TF_VAR_confluent_cloud_api_secret="ENVDEPLOYERAPISECRET"
    cd 1-env-sr-cluster/
    terraform init
    terraform validate
    terraform plan
    terraform apply

## 2 - Create cluster + SA cluster deployer + SA apps

To create the cluster and service accounts, OrgAdmin permission is needed, so the key above is used here.

    export TF_VAR_confluent_cloud_api_key="ENVDEPLOYERAPIKEY"
    export TF_VAR_confluent_cloud_api_secret="ENVDEPLOYERAPISECRET"
     
    cd 2-cluster-sa/
    terraform init
    terraform validate
    terraform plan
    -> fail due to the env invalid
    -> update from result from last launch
    terraform apply -auto-approve

## 3 - Create topics and RBAC
    
In the previous step we created a new service account to control this cluster, so we will use the permissions here (use the min permission needed)

    cat 2-cluster-sa/outputs/service-account-cluster-stage-deployer.txt

    export TF_VAR_confluent_kafka_api_key="CLUSTERDEPLOYERKAFKAAPIKEY"
    export TF_VAR_confluent_kafka_api_secret="CLUSTERDEPLOYERKAFKAAPISECRET"
    export TF_VAR_confluent_cloud_api_key="CLUSTERDEPLOYERCLOUDAPIKEY"
    export TF_VAR_confluent_cloud_api_secret="CLUSTERDEPLOYERCLOUDAPISECRET"

    cd 3-topics-service-accounts
    terraform init
    terraform validate
    terraform plan
    -> fail due to the invalid data
    -> update from result from last launch
    terraform apply -auto-approve

## 4 - Add more RBAC

Uncommenting rbac lines to create new resources (comparing the resources with the tfstate)

    terraform validate
    terraform plan
    terraform apply -auto-approve

## 5 - Remove permissions

Comment rbac to force resource destructions (comparing the resources with the tfstate)

    terraform validate
    terraform plan
    terraform apply -auto-approve

## 5 - Destroy resources

Time to clean up!
    
    cd 3-topics-service-accounts
    terraform destroy
    
    cd ../2-cluster-sa
    terraform destroy
    -> fail as cloud api has not enough permissions
    
    export TF_VAR_confluent_cloud_api_key="ENVDEPLOYERAPIKEY"
    export TF_VAR_confluent_cloud_api_secret="ENVDEPLOYERAPISECRET"
    terraform destroy
    
    cd ../1-env-sr-cluster
    terraform destroy

## 6 - Import DEV
    
    export TF_LOG_PATH="./logs/full_log.txt"
    export TF_LOG=trace
    export TF_VAR_confluent_cloud_api_key="ENVDEPLOYERAPIKEY"
    export TF_VAR_confluent_cloud_api_secret="ENVDEPLOYERAPISECRET"

    terraform init
    terraform validate
    terraform plan
    terraform apply -auto-approve
