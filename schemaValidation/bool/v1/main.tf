locals {
  has_default_value            = var.schema.validations.has_default_value
  has_compatible_default_value = can(tobool(var.schema.validations.default_value))

  default_value = local.has_compatible_default_value ? tobool(var.schema.validations.default_value) : false

  has_valid_value     = var.manifest != null && can(tobool(var.manifest))
  final_default_value = local.has_compatible_default_value ? local.default_value : try(tobool(var.manifest), null)


}


output "debug" {
  value = {
    default_value       = local.default_value
    has_default_value   = local.has_default_value
    has_valid_value     = local.has_valid_value
    final_default_value = local.final_default_value
  }
}


output "resource" {
  value = local.has_valid_value ? tobool(var.manifest) : local.final_default_value

  precondition {
    #condition     = local.has_default_value || var.manifest != null
    condition = !(
      !local.has_default_value && var.manifest == null
    )
    error_message = <<-EOT
      Invalid resource manifest!
      The property "${var.field_path}" can not be null.
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = can(tobool(var.manifest))
    error_message = <<-EOT
      Invalid resource manifest!
      The type of the property "${var.field_path}" must be bool.
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = local.has_compatible_default_value
    error_message = <<-EOT
      Invalid resource manifest!
      The default value of the property "${var.field_path}" must be compatible with type bool.
      Current default value: ${format("%v", var.schema.validations.default_value)}
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }
}
