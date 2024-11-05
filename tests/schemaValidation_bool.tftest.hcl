run "check_can_validate_bool_v0" {
  command = plan
  module {
    source = "./schemaValidation/bool"
  }


  variables {
    metadata_name = "teste-manifest"
    path          = "."
    field_path    = "spec.teste"
    manifest      = true

    schema = {
      type    = "bool"
      version = "v0"
      subItem = null
      validations = {
        default_value     = null
        has_default_value = false
      }
    }
  }


  assert {
    condition = output.resource == true

    error_message = "Não validou um campo bool v0"
  }
}

run "check_can_validate_bool_v1" {
  command = plan
  module {
    source = "./schemaValidation/bool"
  }

  variables {
    metadata_name = "teste-manifest"
    path          = "."
    field_path    = "spec.teste"
    manifest      = true

    schema = {
      type    = "bool"
      version = "v1"
      subItem = null
      validations = {
        default_value     = null
        has_default_value = false
      }
    }
  }


  assert {
    condition = output.resource == true

    error_message = "Não validou campo bool v1. output.resource = ${format("%v", output.resource)}"
  }

}
