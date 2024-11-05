module "version" {
  source = "./version"
  count  = try(length(var.manifest.spec.versions), 0)

  metadata_name = var.manifest.metadata.name
  path          = var.path
  field_path    = "spec.versions[${count.index}]"
  manifest      = try(var.manifest.spec.versions[count.index], null)
}

output "schema" {
  value = {
    path     = var.path
    name     = var.manifest.metadata.name
    group    = try(var.manifest.spec.group, null)
    kind     = try(var.manifest.spec.kind, null)
    versions = { for _, value in module.version : value.schema.name => value.schema }
  }

  precondition {
    condition     = can(var.manifest.spec.group)
    error_message = <<-EOT
      Invalid manifest.
      The "spec.group" field is required.
      (metadata.name: "${var.manifest.metadata.name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = can(var.manifest.spec.kind)
    error_message = <<-EOT
      Invalid manifest.
      The "spec.kind" field is required.
      (metadata.name: "${var.manifest.metadata.name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = can(var.manifest.spec.versions)
    error_message = <<-EOT
      Invalid manifest.
      The "spec.versions" field is required.
      (metadata.name: "${var.manifest.metadata.name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = !can(var.manifest.spec.versions) || can(length(var.manifest.spec.versions))
    error_message = <<-EOT
      Invalid manifest.
      The "spec.versions" field must be an array.
      (metadata.name: "${var.manifest.metadata.name}", path: "${var.path}")
    EOT
  }
}
