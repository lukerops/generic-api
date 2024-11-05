run "without_field_value_whithout_default_value" {
  command = plan
  module {
    source = "./schemaValidation/bool/v1/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "bool"
      version = "v1"
      subItem = null
      validations = {
        default_value     = null
        has_default_value = false
      }
    }
    manifest = null
  }

  assert {
    condition     = output.resource == null
    error_message = "Não deveria ter preenchido o valor de um campo obrigatório que não está preenchido no manifesto original"
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_invalid_value" {
  command = plan
  module {
    source = "./schemaValidation/bool/v1/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "bool"
      version = "v1"
      subItem = null
      validations = {
        default_value     = null
        has_default_value = false
      }
    }
    manifest = "test"
  }

  assert {
    condition     = output.resource == null
    error_message = "Não deveria ter preenchido o valor de um campon que está inválido no manifesto original"
  }

  expect_failures = [
    output.resource,
  ]
}



run "with_invalid_value_with_default_value" {
  command = plan
  module {
    source = "./schemaValidation/bool/v1/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "bool"
      version = "v1"
      subItem = null
      validations = {
        default_value     = true
        has_default_value = true
      }
    }
    manifest = "test"
  }

  assert {
    condition     = output.resource == null
    error_message = "Não deveria ter preenchido o valor de um campo inválido com o default value"
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_valid_value_without_default_value" {
  command = plan
  module {
    source = "./schemaValidation/bool/v1/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "bool"
      version = "v1"
      subItem = null
      validations = {
        default_value     = null
        has_default_value = false
      }
    }
    manifest = true
  }

  assert {
    condition     = output.resource == true
    error_message = "Error: Não preencheu o campo com um valor válido"
  }
}

run "with_valid_value_with_default_value" {
  command = plan
  module {
    source = "./schemaValidation/bool/v1/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "bool"
      version = "v1"
      subItem = null
      validations = {
        default_value     = false
        has_default_value = true
      }
    }
    manifest = true
  }

  assert {
    condition     = output.resource == true
    error_message = <<-EOT
    Error: Substituiu o valor do campo pelo valor default, mesmo o campo tendo um valor válido.
    default_value = false
    manifest = true
    output.resource = ${output.resource}
EOT
  }
}


run "without_field_value_with_defaut_value_false" {
  command = plan
  module {
    source = "./schemaValidation/bool/v1/"
  }


  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "bool"
      version = "v1"
      subItem = null
      validations = {
        default_value     = false
        has_default_value = true
      }
    }
    manifest = null
  }

  assert {
    condition     = output.resource == false
    error_message = <<-EOT
    ${format("%#v", output.debug)}    
EOT
  }
}


run "without_field_value_with_defaut_value_true" {
  command = plan
  module {
    source = "./schemaValidation/bool/v1/"
  }


  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "bool"
      version = "v1"
      subItem = null
      validations = {
        default_value     = true
        has_default_value = true
      }
    }
    manifest = null
  }

  assert {
    condition     = output.resource == true
    error_message = "Error when filling default value for boolean field"
  }
}

run "with_default_value_incompatible_with_type_bool" {

  command = plan
  module {
    source = "./schemaValidation/bool/v1/"
  }


  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "bool"
      version = "v1"
      subItem = null
      validations = {
        default_value     = 42
        has_default_value = true
      }
    }
    manifest = null
  }


  expect_failures = [
    output.resource
  ]

}

run "with_default_value_incompatible_with_type_bool_manifest_with_valid_value" {
  # Mesmo que o manifesto tenha um valor válido para o campo 
  # não podemos permitir que o CRD tenha um default value incompatível

  command = plan
  module {
    source = "./schemaValidation/bool/v1/"
  }


  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "bool"
      version = "v1"
      subItem = null
      validations = {
        default_value     = 42
        has_default_value = true
      }
    }
    manifest = true
  }


  expect_failures = [
    output.resource
  ]

}
