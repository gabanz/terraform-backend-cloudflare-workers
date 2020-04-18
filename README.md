# Terraform Backend: Cloudflare Workers
A [Terraform backend](https://www.terraform.io/docs/backends/types/http.html) implementation using Cloudflare Workers.

## So what's this?
This repo contains [Cloudflare Worker](https://developers.cloudflare.com/workers/) as a remote state backend for Terraform. The advantage of storing this in something like Cloudflare instead of AWS S3 is that it's much easier to set up.

This backend supports state locks and an having arbitrary number of Terraform states on a single worker (using different pathnames).

## Prerequisites
- You'll need to install [Terraform CLI](https://learn.hashicorp.com/terraform/getting-started/install.html).
- You'll also need a Cloudflare account (paid account needed due to the use of KV).

There are 2 ways to deploy:
1. Using Terraform itself
2. Using Wrangler

## Method 1:

First, add your Cloudflare account ID and API token in `terraform.tfvars`.

(Optional)
If you wish to deploy this in your own zone, add the zone ID and URL pattern as well.
Also, uncomment the corresponding parts in `variables.tf` and `workers.tf`.

Then, update the credentials in the `index.js` file. **IMPORTANT**

When you're ready:

```sh
terraform init
terraform plan
terraform apply
```

## Method 2:
Install [Cloudflare Wrangler CLI](https://github.com/cloudflare/wrangler#installation)

Make sure your Wrangler CLI is set up correctly by running the following (you might need to generate an API token):
```sh
wrangler config
```

Then, update the credentials in the `index.js` file. **IMPORTANT**

Now, you'll need to create a KV namespace. Just run the following:
```sh
wrangler kv:namespace create TERRAFORM
```

Lastly, to deploy your worker, update `wrangler.toml` file with your account id, kv namespace id, and optionally a different project name, then run the following:
```sh
wrangler publish
```

You should get back a message similar to the following:
```
💁  JavaScript project found. Skipping unnecessary build!
✨  Successfully published your script to https://terraform-backend.ACCOUNT_NAME.workers.dev
```

Congrats! You're done. This will give you the url for your Terraform backend, which you should then be able to add to your terraform:
```hcl
terraform {
  backend "http" {
    address = "https://terraform-backend.ACCOUNT_NAME.workers.dev/"
    username = "CHANGE ME!"
    password = "CHANGE ME!"
  }
}
```

**Caution:** Changing your credentials after running `terraform init` is not supported as it's not straightforward. If that's needed, try taking a copy of your state before changing your credentials, then uploading it after you make the change:
```sh
# Before changing your credentials
tf state pull > state-backup.tfstate

# Change your credentials...
wrangler publish

# After changing your credentials (including in the terraform config)
tf state push state-backup.tfstate