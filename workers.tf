resource "cloudflare_workers_kv_namespace" "terraform-ns" {
  title = "TERRAFORM"
}

resource "cloudflare_worker_script" "terraform-backend" {
  name = "terraform-backend"
  content = file("index.js")

  kv_namespace_binding {
    name = "TERRAFORM"
    namespace_id = cloudflare_workers_kv_namespace.terraform-ns.id
  }
}

# Uncomment following block if you want to deploy the Terraform backend on your own zone
/*
resource "cloudflare_worker_route" "terraform_route" {
  zone_id = var.cloudflare_zone_id
  pattern = var.url_pattern
  script_name = cloudflare_worker_script.terraform-backend.name
}
*/
