module "v0" {
  source = "../../schemaProcessor/bool/v0/validator/"
  count  = var.schema.version == "v0" ? 1 : 0

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = var.field_path
  manifest      = var.manifest
  schema        = var.schema
}

module "v1" {
  source = "./v1"
  count  = var.schema.version == "v1" ? 1 : 0

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = var.field_path
  manifest      = var.manifest
  schema        = var.schema
}

output "resource" {
  value = one(
    concat(
      module.v0[*].resource,
      module.v1[*].resource,
    )
  )
}
