resource "google_cloud_run_service" "this" {
  name = "ecom-app"
  location = var.region
  
  template {
    spec {
      containers {
        image = var.app_image
        ports {
          container_port = var.container_port
        }
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "3"
        "autoscaling.knative.dev/minScale" = "0"
      }
    }
  }

}

resource "google_cloud_run_service_iam_member" "allow-all" {
  service  = google_cloud_run_service.this.name
  location = google_cloud_run_service.this.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}