##################################### TAG NAMESPACE #####################################
module "tag_namespace" {
  source         = "/landing_zone/primary/tag/tag_namespace"
  for_each       = var.tag_namespace_configurations
  tenancy_ocid   = var.tenancy_ocid
  namespace_name = each.value.namespace_name
}

####################################### TAG #############################################
module "tag" {
  source           = "/landing_zone/primary/tag"
  for_each         = var.tag_configurations
  name             = each.value.name
  tag_namespace_id = module.tag_namespace[each.value.tag_namespace_key].tag_namespace_id
  values           = each.value.values
}

####################################### COMPARTMENT #######################################
module "compartment" {
  source                     = "/landing_zone/primary/compartment"
  compartments_configuration = var.compartments_configuration
  tenancy_ocid               = var.tenancy_ocid
}

########################################## VCN ##########################################
module "vcn" {
  source         = "/landing_zone/primary/vcn"
  for_each       = var.vcn_configurations
  cidr_block     = each.value.cidr_block
  display_name   = each.value.display_name
  compartment_id = lookup(module.compartment.compartments, each.value.compartment_key).id
  defined_tags   = each.value.defined_tags
}

########################################## BASTION ##########################################
module "bastion" {
  #  region           = each.value.region
  source                               = "/landing_zone/primary/bastion"
  for_each                             = var.bastion_configurations
  compartment_id                       = lookup(module.compartment.compartments, each.value.compartment_key).id
  target_subnet_id                     = module.subnet[each.value.target_subnet_key].target_subnet_id
  bastion_client_cidr_block_allow_list = each.value.bastion_client_cidr_block_allow_list
  bastion_name                         = each.value.bastion_name
  bastion_bastion_type                 = each.value.bastion_bastion_type
  bastion_max_session_ttl_in_seconds   = each.value.bastion_max_session_ttl_in_seconds
  defined_tags                         = each.value.defined_tags
}

########################################## SUBNET ##########################################
module "subnet" {
  source            = "/landing_zone/primary/subnet"
  for_each          = var.subnet_configurations
  compartment_id    = lookup(module.compartment.compartments, each.value.compartment_key).id
  vcn_id            = module.vcn[each.value.vcn_key].vcn_id
  cidr_block        = each.value.cidr_block
  route_table_id    = module.route_table[each.value.route_table_key].route_table_id
  security_list_ids = module.security_list[each.value.security_list_key].security_list_id
  display_name      = each.value.display_name
  defined_tags      = each.value.defined_tags
}

########################################## BUCKET ##########################################
module "bucket" {
  source              = "/landing_zone/primary/buckets"
  for_each            = var.bucket_configurations
  compartment_id      = lookup(module.compartment.compartments, each.value.compartment_key).id
  bucket_name         = each.value.bucket_name
  bucket_namespace    = each.value.bucket_namespace
  bucket_storage_tier = each.value.bucket_storage_tier
  defined_tags        = each.value.defined_tags
}

########################################## TOPICS ##########################################
module "topic" {
  source                         = "/landing_zone/primary/topic"
  for_each                       = var.topic_configurations
  compartment_id                 = lookup(module.compartment.compartments, each.value.compartment_key).id
  notification_topic_name        = each.value.notification_topic_name
  notification_topic_description = each.value.notification_topic_description
  defined_tags                   = each.value.defined_tags
}

########################################## SERVICE GATEWAY ##########################################
module "service_gateway" {
  source                       = "/landing_zone/primary/service_gateway"
  for_each                     = var.service_gateway_configurations
  compartment_id               = lookup(module.compartment.compartments, each.value.compartment_key).id
  vcn_id                       = module.vcn[each.value.vcn_key].vcn_id
  service_gateway_display_name = each.value.service_gateway_display_name
  defined_tags                 = each.value.defined_tags
}

########################################## INTERNET GATEWAY ##########################################
module "internet_gateway" {
  source                        = "/landing_zone/primary/internet_gateway"
  for_each                      = var.internet_gateway_configurations
  compartment_id                = lookup(module.compartment.compartments, each.value.compartment_key).id
  vcn_id                        = module.vcn[each.value.vcn_key].vcn_id
  internet_gateway_display_name = each.value.internet_gateway_display_name
  internet_gateway_enabled      = each.value.internet_gateway_enabled
  defined_tags                  = each.value.defined_tags
}

########################################## NAT GATEWAY ##########################################
module "nat_gateway" {
  source                   = "/landing_zone/primary/nat_gateway"
  for_each                 = var.nat_gateway_configurations
  compartment_id           = lookup(module.compartment.compartments, each.value.compartment_key).id
  vcn_id                   = module.vcn[each.value.vcn_key].vcn_id
  nat_gateway_display_name = each.value.nat_gateway_display_name
  defined_tags             = each.value.defined_tags
}

########################################## SECURITY LISTS ##########################################
module "security_list" {
  source                     = "/landing_zone/primary/security_list"
  for_each                   = var.security_list_configurations
  compartment_id             = lookup(module.compartment.compartments, each.value.compartment_key).id
  vcn_id                     = module.vcn[each.value.vcn_key].vcn_id
  security_list_display_name = each.value.security_list_display_name
  defined_tags               = each.value.defined_tags
}

########################################## ROUTE TABLE ##########################################
module "route_table" {
  source                   = "/landing_zone/primary/route_table"
  for_each                 = var.route_table_configurations
  compartment_id           = lookup(module.compartment.compartments, each.value.compartment_key).id
  vcn_id                   = module.vcn[each.value.vcn_key].vcn_id
  route_table_display_name = each.value.route_table_display_name
  defined_tags             = each.value.defined_tags
  network_entity_id        = module.nat_gateway[each.value.network_entity_key].nat_gateway_id
}

########################################## DRG ##########################################
module "drg" {
  source         = "/landing_zone/primary/drg/drg"
  for_each       = var.drg_configurations
  compartment_id = lookup(module.compartment.compartments, each.value.compartment_key).id
  display_name   = each.value.display_name
  defined_tags   = each.value.defined_tags
}

########################################## DRG ATTACHMENT ##########################################
module "drg_attachment" {
  source                              = "/landing_zone/primary/drg/drg_attachment"
  for_each                            = var.drg_attachment_configurations
  display_name                        = each.value.display_name
  drg_id                              = module.drg[each.value.drg_key].drg_id
  drg_route_table_id                  = module.drg_route_table[each.value.drg_route_table_key].drg_route_table_id
  attachment_id                       = module.vcn[each.value.vcn_key].vcn_id
  drg_attachment_network_details_type = each.value.drg_attachment_network_details_type

}

########################################## DRG ROUTE DISTRIBUTION ##########################################
module "drg_route_distribution" {
  source            = "/landing_zone/primary/drg/drg_route_distribution"
  for_each          = var.drg_route_distribution_configurations
  display_name      = each.value.display_name
  distribution_type = each.value.distribution_type
  drg_id            = module.drg[each.value.drg_key].drg_id
}

################################## DRG ROUTE DISTRIBUTION STATEMENT ####################################
module "drg_route_distribution_statement" {
  source                    = "/landing_zone/primary/drg/drg_route_distribution_statement"
  for_each                  = var.drg_route_distribution_statement_configurations
  drg_route_distribution_id = module.drg_route_distribution[each.value.drg_route_distribution_key].drg_route_distribution_id
  action                    = each.value.action
  match_type                = each.value.match_type
  attachment_type           = each.value.attachment_type
  drg_attachment_id         = module.drg_attachment[each.value.drg_attachment_key].drg_attachment_id
  priority                  = each.value.priority
}

################################## DRG ROUTE TABLE ##################################
module "drg_route_table" {
  source                    = "/landing_zone/primary/drg/drg_route_table"
  for_each                  = var.drg_route_table_configurations
  display_name              = each.value.display_name
  drg_id                    = module.drg[each.value.drg_key].drg_id
  drg_route_distribution_id = module.drg_route_distribution[each.value.drg_route_distribution_key].drg_route_distribution_id
}

################################## VSS_Host_Scan_Recipe ##################################

module "vss_host_scan_recipe" {
  source                                                     = "/landing_zone/primary/vss/vss_host_scan_recipe"
  for_each                                                   = var.vss_host_scan_recipe_configurations
  agent_scan_level                                           = each.value.host_scan_recipe_agent_settings_scan_level
  host_scan_recipe_agent_settings_agent_configuration_vendor = each.value.host_scan_recipe_agent_settings_agent_configuration_vendor
  cis_scan_level                                             = each.value.host_scan_recipe_agent_settings_agent_configuration_cis_benchmark_settings_scan_level
  compartment_id                                             = lookup(module.compartment.compartments, each.value.compartment_key).id
  port_scan_level                                            = each.value.host_scan_recipe_port_settings_scan_level
  host_scan_recipe_schedule_type                             = each.value.host_scan_recipe_schedule_type
}

################################## VSS_Host_Scan_target ##################################
module "vss_host_scan_target" {
  source                   = "/landing_zone/primary/vss/vss_host_scan_target"
  for_each                 = var.vss_host_scan_target_configurations
  compartment_id           = lookup(module.compartment.compartments, each.value.compartment_key).id
  test_host_scan_recipe_id = module.vss_host_scan_recipe[each.value.test_host_scan_recipe_key].test_host_scan_recipe_id
  target_compartment_id    = lookup(module.compartment.compartments, each.value.compartment_key).id
}

################################## IAM-User ##################################

module "iam-user" {
  source         = "/landing_zone/primary/iam/iam_user"
  for_each       = var.iam_user_configurations
  compartment_id = var.tenancy_ocid
  description    = each.value.description
  user_name      = each.value.user_name
  user_email     = each.value.user_email
}


################################## IAM-Group ##################################

module "iam-group" {
  source         = "/landing_zone/primary/iam/iam_group"
  for_each       = var.iam_group_configurations
  compartment_id = var.tenancy_ocid
  description    = each.value.description
  group_name     = each.value.group_name
}

################################## IAM-Policy_Statements ##################################

module "iam-policy" {
  source            = "/landing_zone/primary/iam/iam_policy"
  for_each          = var.iam_policy_configurations
  compartment_id    = var.tenancy_ocid
  description       = each.value.description
  policy_name       = each.value.policy_name
  policy_statements = each.value.policy_statements
}

################################## user_group_membership ##################################

module "user_group_membership" {
  source       = "/landing_zone/primary/iam/user_group_membership"
  for_each     = var.user_group_membership_configurations
  iam_group_id = module.iam-group[each.value.iam_group_key].iam_group_id
  iam_user_id  = module.iam-user[each.value.iam_user_key].iam_user_id
}

