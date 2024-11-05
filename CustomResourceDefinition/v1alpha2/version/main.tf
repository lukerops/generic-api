module "root_object" {
  source = "../root_object"
  count  = can(var.manifest.specSchema) ? 1 : 0

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.specSchema"
  manifest      = var.manifest.specSchema
}

output "schema" {
  value = {
    name       = try(var.manifest.name, null)
    enabled    = try(var.manifest.enabled, true)
    deprecated = try(var.manifest.deprecated, false)
    schema     = one(module.root_object[*].schema)
  }

  precondition {
    condition     = can(var.manifest.name)
    error_message = <<-EOT
      Missing "name" value.
      The field "${var.field_path}.name" is required.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = can(var.manifest.specSchema)
    error_message = <<-EOT
      Missing "specSchema" value.
      The field "${var.field_path}.specSchema" is required.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }
}
