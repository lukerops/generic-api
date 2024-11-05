locals {
  properties = try({ for key, value in var.manifest.properties : key => value }, {})
}

module "string" {
  source   = "../string"
  for_each = toset([for key, value in local.properties : key if try(value.type, null) == "string"])

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.properties.${each.key}"
  manifest      = var.manifest.properties[each.key]
}

module "integer" {
  source   = "../integer"
  for_each = toset([for key, value in local.properties : key if try(value.type, null) == "integer"])

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.properties.${each.key}"
  manifest      = var.manifest.properties[each.key]
}

module "bool" {
  source   = "../bool"
  for_each = toset([for key, value in local.properties : key if try(value.type, null) == "bool"])

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.properties.${each.key}"
  manifest      = var.manifest.properties[each.key]
}

module "reduced_array" {
  source   = "../reduced_array"
  for_each = toset([for key, value in local.properties : key if try(value.type, null) == "array"])

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.properties.${each.key}"
  manifest      = var.manifest.properties[each.key]
}

output "schema" {
  value = {
    type        = "reduced_object"
    version     = "v1"
    validations = {}
    subItem = {
      for key, value in merge(module.string, module.integer, module.bool, module.reduced_array) : key => value.schema
    }
  }

  precondition {
    condition     = can(var.manifest.properties)
    error_message = <<-EOT
      Invalid object.
      The field "${var.field_path}.properties" are required.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = !can(var.manifest.properties) || can(keys(var.manifest.properties))
    error_message = <<-EOT
      Invalid "properties" value.
      The field "${var.field_path}.properties" must be an object.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = length([for key, value in local.properties : key if try(value.type, null) == null]) == 0
    error_message = <<-EOT
      Invalid "properties" value.
      The field "${var.field_path}.properties" must have a "type" field.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition = alltrue([
      for key, value in local.properties : contains(["string", "integer", "bool", "array"], value.type)
      if can(value.type)
    ])
    error_message = <<-EOT
      Invalid propertie "type".
      The field "${var.field_path}.properties.*.type" must be one of "string", "integer", "bool" or "array".
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }
}
