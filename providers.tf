provider "cloudflare" {
  version = "~> 2.5.1"
  account_id = var.cloudflare_account_id
  api_token = var.cloudflare_api_token
}