output "schema" {
  value = {
    type    = "string"
    version = "v0"
    subItem = null
    validations = {
      minLength = try(tonumber(var.manifest.minLength), null)
      maxLength = try(tonumber(var.manifest.maxLength), null)
    }
  }

  precondition {
    condition     = can(tonumber(try(var.manifest.minLength, null)))
    error_message = <<-EOT
      Invalid "minLength" value.
      The field "${var.field_path}.minLength" must be a number.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = try(tonumber(var.manifest.minLength) >= 0, true)
    error_message = <<-EOT
      Invalid "minLength" value.
      The field "${var.field_path}.minLength" must be greater than or equal to 0.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = can(tonumber(try(var.manifest.maxLength, null)))
    error_message = <<-EOT
      Invalid "maxLength" value.
      The field "${var.field_path}.maxLength" must be a number.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = try(tonumber(var.manifest.maxLength) >= 1, true)
    error_message = <<-EOT
      Invalid "maxLength" value.
      The field "${var.field_path}.maxLength" must be greater than or equal to 1.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = try(var.manifest.minLength < var.manifest.maxLength, true)
    error_message = <<-EOT
      Invalid "minLength" and "maxLength" values.
      The field "${var.field_path}.minLength" must be less than "${var.field_path}.maxLength".
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }
}
