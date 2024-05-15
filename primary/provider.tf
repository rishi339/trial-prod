terraform {
experiments = [module_variable_optional_attrs]
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "5.41.0"
    }
  }
}

provider "oci" {
  alias            = "us-ashburn-1"
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = "us-ashburn-1"
}

