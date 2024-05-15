
output "compartments" {
  description = "The compartments in a single flat map."
  value       = merge(oci_identity_compartment.these, oci_identity_compartment.level_2, oci_identity_compartment.level_3, oci_identity_compartment.level_4, oci_identity_compartment.level_5, oci_identity_compartment.level_6)
}

