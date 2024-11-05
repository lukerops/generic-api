
locals {
  declared_default_field = contains(keys(var.manifest), "default")
}

output "schema" {
  value = {
    type    = "bool"
    version = "v1"
    subItem = null
    validations = {
      has_default_value = can(var.manifest.default) ? true : false
      default_value     = try(var.manifest.default, null)
    }
  }

  precondition {
    condition     = !(
      local.declared_default_field && try(var.manifest.default, null) == null
  )
    error_message = <<-EOT
    Invalid Manifest!
    O valor default de um campo bool não pode ser null;
    O campo ${var.field_path} tem seu default value definido como null.
    (metadata: ${var.metadata_name}; path: ${var.path}; )
EOT
  }
}
