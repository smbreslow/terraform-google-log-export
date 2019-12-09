/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

provider "google" {
  version = "~> 2.0"
}
   
locals {
  datadog_svc = element(google_service_account.datadog-viewer.*.email,0)
}
   
resource "google_service_account" "datadog-viewer" {
  account_id = "${var.project_id}-datadog-viewer"
  description = "Service account for Datadog monitoring"
  project = var.project_id
}
   
resource "google_project_iam_member" "compute-viewer" {
  project = var.project_id
  role    = "roles/compute.viewer"
  member  = "serviceAccount:${var.project_id}-datadog-viewer@${var.project_id}.iam.gserviceaccount.com"
}
   
resource "google_project_iam_member" "cloudasset-viewer" {
  project = var.project_id
  role    = "roles/cloudasset.viewer"
  member  = "serviceAccount:${var.project_id}-datadog-viewer@${var.project_id}.iam.gserviceaccount.com"
}
   
resource "google_project_iam_member" "monitoring-viewer" {
  project = var.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${var.project_id}-datadog-viewer@${var.project_id}.iam.gserviceaccount.com"
}
   
module "log_export" {
  source               = "github.com/smbreslow/terraform-google-log-export.git/"
  destination_uri      = module.destination.destination_uri
  log_sink_name        = "test-datadog-sink"
  parent_resource_id   = var.parent_resource_id
  parent_resource_type = "project"
  unique_writer_identity = true
}

module "destination" {
  source                   = "github.com/smbreslow/terraform-google-log-export.git/modules/pubsub"
  project_id               = var.project_id
  topic_name               = "datadog-sink"
  log_sink_writer_identity = module.log_export.writer_identity
  create_subscriber        = true
  push_subscriber          = true
  push_endpoint            = var.push_endpoint
}
