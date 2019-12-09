# Datadog sink example

The solution helps you set up a log-streaming pipeline from Stackdriver Logging to Datadog.

## Instructions

1. Fill the required variables in the `terraform.tfvars` file located in this directory.

2. Verify the IAM roles for your Terraform service account:
    - `roles/logging.configWriter` on the project (to create the logsink)
    - `roles/iam.admin` on the project (to grant write permissions for logsink service account)
    - `roles/serviceusage.admin` on the destination project (to enable destination API)
    - `roles/pubsub.admin` on the destination project (to create a pub/sub topic)
    - `roles/serviceAccount.admin` on the destination project (to create a service account for the logsink subscriber)

2. Run the Terraform automation:
    ```
    terraform init
    terraform apply
    ```

    You should see similar outputs as the following:

    ![screen shot 2019-01-25 at 1 21 14 pm](https://user-images.githubusercontent.com/9629314/51767833-23459980-20a4-11e9-831c-01a2943ee745.png)

3. In the GCP console, under `IAM > Service Accounts`, find the Pub/Sub subscriber service account and create a set of JSON credentials:

    ![screen shot 2019-01-25 at 1 24 27 pm](https://user-images.githubusercontent.com/9629314/51767992-8fc09880-20a4-11e9-8e69-aa8b3f6e360d.png)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| parent\_resource\_id | The ID of the project in which pubsub topic destination will be created. | string | n/a | yes |
| project\_id | The ID of the project in which the log export will be created. | string | n/a | yes |
| push\_endpoint | The URL locating the endpoint to which messages should be pushed. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| pubsub\_subscriber | Pub/Sub topic subscriber email |
| pubsub\_subscription\_name | Pub/Sub topic subscription name |
| pubsub\_topic\_name | Pub/Sub topic name |
| pubsub\_topic\_project | Pub/Sub topic project id |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
