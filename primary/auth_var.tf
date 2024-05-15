# -----------------------------------------------------------------------------
#                           Authentication Variables
# -----------------------------------------------------------------------------
variable "tenancy_ocid" {
  type        = string
  description = "The OCID of tenancy"
}

variable "user_ocid" {
  type        = string
  description = "The OCID of User"
}

variable "fingerprint" {
  type        = string
  description = "The fingerprint of User"
}

variable "private_key_path" {
  type        = string
  description = "The private_key_path of Key"
}

variable "primary_region" {
  type        = string
  description = "The OCI region for Primary Environment"
}

variable "enable_compartment_delete" {
  type        = bool
  description = "Set to true to allow the compartments to delete on terraform destroy."
  default     = true
}

