variable "cloudflare_account_id" {
  description = "Your Cloudflare Account ID"
}


variable "cloudflare_api_token" {
  description = "Use the pre-configured Edit Cloudflare Workers	permissions"
}

# Uncomment following block if you want to deploy the Terraform backend on your own zone
/*
variable "cloudflare_zone_id" {
  description = "The Zone ID to deploy the Workers route to"
}

variable "url_pattern" {
  description = "The URL pattern to deploy the Workers route to"
}
*/