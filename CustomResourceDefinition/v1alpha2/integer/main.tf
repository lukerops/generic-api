output "schema" {
  value = {
    type    = "integer"
    version = "v0"
    subItem = null
    validations = {
      minimum = try(tonumber(var.manifest.minimum), null)
      maximum = try(tonumber(var.manifest.maximum), null)
    }
  }

  precondition {
    condition     = can(tonumber(try(var.manifest.minimum, null)))
    error_message = <<-EOT
      Invalid "minimum" value.
      The field "${var.field_path}.minimum" must be a number.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = can(tonumber(try(var.manifest.maximum, null)))
    error_message = <<-EOT
      Invalid "maximum" value.
      The field "${var.field_path}.maximum" must be a number.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = try(var.manifest.minimum < var.manifest.maximum, true)
    error_message = <<-EOT
      Invalid "minimum" and "maximum" values.
      The field "${var.field_path}.minimum" must be less than "${var.field_path}.maximum".
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }
}
