run "missing_value" {
  command = plan
  module {
    source = "./schemaValidation/reduced_object/v1/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "reduced_object"
      version     = "v1"
      validations = {}
      subItem = {
        stringProperty = {
          type    = "string"
          version = "v0"
          subItem = null
          validations = {
            minLength = null
            maxLength = null
          }
        }
      }
    }
    manifest = null
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_invalid_value" {
  command = plan
  module {
    source = "./schemaValidation/reduced_object/v1/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "reduced_object"
      version     = "v1"
      validations = {}
      subItem = {
        stringProperty = {
          type    = "string"
          version = "v0"
          subItem = null
          validations = {
            minLength = null
            maxLength = null
          }
        }
      }
    }
    manifest = [1]
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_valid_value" {
  command = plan
  module {
    source = "./schemaValidation/reduced_object/v1/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "reduced_object"
      version     = "v1"
      validations = {}
      subItem = {
        stringProperty = {
          type    = "string"
          version = "v0"
          subItem = null
          validations = {
            minLength = 1
            maxLength = null
          }
        }
        integerProperty = {
          type    = "integer"
          version = "v0"
          subItem = null
          validations = {
            minimum = 1
            maximum = null
          }
        }
        boolProperty = {
          type        = "bool"
          version     = "v0"
          subItem     = null
          validations = {}
        }
      }
    }
    manifest = {
      stringProperty  = "test"
      integerProperty = 1
      boolProperty    = true
    }
  }

  assert {
    condition = output.resource == {
      stringProperty  = "test"
      integerProperty = 1
      boolProperty    = true
    }
    error_message = "Error when validating reduced_object."
  }
}

run "can_have_null_bool_field_with_default_value" {

  command = plan
  module {
    source = "./schemaValidation/reduced_object/v1"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "reduced_object"
      version     = "v1"
      validations = {}
      subItem = {
        active = {
          type    = "bool"
          version = "v1"
          subItem = null
          validations = {
            default_value     = false
            has_default_value = true
          }
        }
      }
    }
    manifest = {
      active = null
    }
  }

  assert {
    condition = output.resource.active == false

    error_message = "Error: Não preencheu campo bool com default value"
  }

}

run "can_have_absent_bool_field_with_default_value" {

  command = plan
  module {
    source = "./schemaValidation/reduced_object/v1"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "object"
      version     = "v1"
      validations = {}
      subItem = {
        active = {
          type    = "bool"
          version = "v1"
          subItem = null
          validations = {
            default_value     = true
            has_default_value = true
          }
        }
      }
    }
    manifest = {
      #active = null
    }
  }

  assert {
    condition = output.resource.active == true

    error_message = "Error: Não preencheu campo bool com default value"
  }
}
