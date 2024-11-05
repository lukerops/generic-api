locals {
  types_with_default_value_support = ["bool"]


  properties = keys(var.schema.subItem)
  missing_properties = [
    for property in local.properties : property
    if !can(var.manifest[property])
    && !contains(
      local.types_with_default_value_support,
      var.schema.subItem[property].type
    )
  ]
}

module "string" {
  source = "../../string"
  for_each = {
    for k, v in var.schema.subItem :
    k => v
    if v.type == "string"
    && !contains(local.missing_properties, k)
  }

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.${each.key}"
  manifest      = try(var.manifest[each.key], null)
  schema        = each.value
}

module "integer" {
  source   = "../../integer"
  for_each = { for k, v in var.schema.subItem : k => v if v.type == "integer" && !contains(local.missing_properties, k) }

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.${each.key}"
  manifest      = var.manifest[each.key]
  schema        = each.value
}

module "bool" {
  source = "../../bool"
  for_each = {
    for k, v in var.schema.subItem :
    k => v
    if v.type == "bool"
    && !contains(local.missing_properties, k)
  }

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.${each.key}"
  manifest      = try(var.manifest[each.key], null)
  schema        = each.value
}

module "array" {
  source   = "../../array"
  for_each = { for k, v in var.schema.subItem : k => v if v.type == "array" && !contains(local.missing_properties, k) }

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.${each.key}"
  manifest      = var.manifest[each.key]
  schema        = each.value
}

module "object" {
  source   = "../../object"
  for_each = { for k, v in var.schema.subItem : k => v if v.type == "object" && !contains(local.missing_properties, k) }

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.${each.key}"
  manifest      = var.manifest[each.key]
  schema        = each.value
}

output "resource" {
  value = { for k, v in merge(module.string, module.integer, module.bool, module.array, module.object) : k => v.resource }

  precondition {
    condition     = var.manifest != null
    error_message = <<-EOT
      Invalid resource manifest!
      The property "${var.field_path}" can not be null.
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = can(keys(var.manifest))
    error_message = <<-EOT
      Invalid resource manifest!
      The type of the property "${var.field_path}" must be object.
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = length(local.missing_properties) == 0
    error_message = <<-EOT
        Invalid resource manifest!
        The field "${var.field_path}" is missing the following properties: ${join(", ", local.missing_properties)}.
        (metadata.name: "${var.metadata_name}"; path: "${var.path}")
      EOT
  }
}
