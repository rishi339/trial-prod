variable "compartments_configuration" {
  description = "The compartments configuration. Use the compartments attribute to define your topology. OCI supports compartment hierarchies up to six levels."
  type = object({
    default_parent_id     = optional(string)
    default_defined_tags  = optional(map(string))
    default_freeform_tags = optional(map(string))
    enable_delete         = optional(bool)
    compartments = map(object({
      name          = string
      description   = string
      parent_id     = optional(string)
      defined_tags  = optional(map(string))
      freeform_tags = optional(map(string))
      #      tag_defaults     = optional(map(object({
      #        tag_id = string,
      #        default_value = string,
      #        is_user_required = optional(bool)
      #      })))
      children = optional(map(object({
        name          = string
        description   = string
        defined_tags  = optional(map(string))
        freeform_tags = optional(map(string))
        #        tag_defaults     = optional(map(object({
        #            tag_id = string,
        #            default_value = string,
        #            is_user_required = optional(bool)
        #          })))
        children = optional(map(object({
          name          = string
          description   = string
          defined_tags  = optional(map(string))
          freeform_tags = optional(map(string))
          #          tag_defaults     = optional(map(object({
          #            tag_id = string,
          #            default_value = string,
          #            is_user_required = optional(bool)
          #          })))
          children = optional(map(object({
            name          = string
            description   = string
            defined_tags  = optional(map(string))
            freeform_tags = optional(map(string))
            #            tag_defaults     = optional(map(object({
            #              tag_id = string,
            #              default_value = string,
            #              is_user_required = optional(bool)
            #            })))
            children = optional(map(object({
              name          = string
              description   = string
              defined_tags  = optional(map(string))
              freeform_tags = optional(map(string))
              #              tag_defaults     = optional(map(object({
              #                tag_id = string,
              #                default_value = string,
              #                is_user_required = optional(bool)
              #              })))
              children = optional(map(object({
                name          = string
                description   = string
                defined_tags  = optional(map(string))
                freeform_tags = optional(map(string))
                #                tag_defaults     = optional(map(object({
                #                  tag_id = string,
                #                  default_value = string,
                #                  is_user_required = optional(bool)
                #                })))
              })))
            })))
          })))
        })))
      })))
    }))
  })
  default = null
}

variable "derive_keys_from_hierarchy" {
  description = "Whether identifying keys should be derived from the provided compartments hierarchy"
  type        = bool
  default     = false
}

variable "module_name" {
  description = "The module name."
  type        = string
  default     = "iam-compartments"
}

variable "tags_dependency" {
  description = "A map of objects containing the externally managed tags this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the tag OCID) of string type. See 'External Dependencies' section in README.md for details."
  type = map(object({
    id = string
  }))
  default = null
}

variable "compartments_dependency" {
  description = "A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain an 'id' attribute of string type set with the compartment OCID. See 'External Dependencies' section in README.md for details."
  type = map(object({
    id = string
  }))
  default = null
}

variable "tenancy_ocid" {
  type = string
}

