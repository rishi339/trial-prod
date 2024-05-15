# -----------------------------------------------------------------------------
# Support for multi-region deployments
# -----------------------------------------------------------------------------
data "oci_identity_region_subscriptions" "regions" {
  tenancy_id = var.tenancy_ocid
}

data "oci_core_services" "services" {
}

data "oci_identity_regions" "regions" {}

data "oci_identity_tenancy" "tenancy" {
  tenancy_id = var.tenancy_ocid
}

locals {
  region_map = { for r in data.oci_identity_regions.regions.regions : r.key => r.name }
}

