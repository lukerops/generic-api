run "can_parse_reduced_object_v0" {
  command = plan
  module {
    source = "./schemaValidation/reduced_object"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "reduced_object"
      version     = "v0"
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

run "can_parse_reduced_object_v1" {
  command = plan
  module {
    source = "./schemaValidation/reduced_object"
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
