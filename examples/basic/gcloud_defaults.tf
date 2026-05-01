# ---------------------------------------------------------------------------------------------------------------------
# Auto-detect defaults from the local gcloud config so users with `gcloud config set project ...`
# can `terraform apply` without supplying any -var flags.
#
# Resolution order (first non-empty wins):
#   1. Explicit -var / terraform.tfvars value
#   2. `gcloud config get-value <key>`
#   3. Hard-coded fallback (region/zone only). project_id has no fallback and will fail validation.
# ---------------------------------------------------------------------------------------------------------------------

data "external" "gcloud_config" {
  program = ["bash", "-c", <<-EOT
    jq -n \
      --arg project         "$(gcloud config get-value project 2>/dev/null || true)" \
      --arg region          "$(gcloud config get-value compute/region 2>/dev/null || true)" \
      --arg zone            "$(gcloud config get-value compute/zone 2>/dev/null || true)" \
      --arg account         "$(gcloud config get-value account 2>/dev/null || true)" \
      --arg billing_project "$(gcloud config get-value billing/quota_project 2>/dev/null || true)" \
      '{project:$project, region:$region, zone:$zone, account:$account, billing_project:$billing_project}'
  EOT
  ]
}

locals {
  _g                 = data.external.gcloud_config.result
  _g_project         = trimspace(local._g.project)
  _g_region          = trimspace(local._g.region)
  _g_zone            = trimspace(local._g.zone)
  _g_billing_project = trimspace(local._g.billing_project)
  _g_account         = trimspace(local._g.account)

  project_id = coalesce(
    var.project_id,
    local._g_project != "" ? local._g_project : null,
  )

  region = coalesce(
    var.region,
    local._g_region != "" ? local._g_region : null,
    "us-central1",
  )

  zone = coalesce(
    var.zone,
    local._g_zone != "" ? local._g_zone : null,
    "${local.region}-a",
  )

  billing_project = local._g_billing_project != "" ? local._g_billing_project : null
}

resource "terraform_data" "validate_project" {
  lifecycle {
    precondition {
      condition     = local.project_id != null && local.project_id != ""
      error_message = "Could not resolve project_id. Run `gcloud config set project <PROJECT_ID>` or pass -var='project_id=<PROJECT_ID>'."
    }
  }
}
