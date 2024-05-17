terraform {
  required_version = "< 1.3.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "5.41.0" 
    }
  }
  experiments = ["module_variable_optional_attrs"]
}

provider "oci" {
  alias            = "us-ashburn-1"
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = "var.primary_region"
}

