run "without_properties" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/object"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "object"
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_invalid_properties" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/object"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type       = "object"
      properties = "invalid"
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_properties_missing_type" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/object"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "object"
      properties = {
        test = {}
      }
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_properties_invalid_type" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/object"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "object"
      properties = {
        test = {
          type = "invalid"
        }
      }
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_properties" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/object"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "object"
      properties = {
        boolProperty = {
          type = "bool"
        }
        stringProperty = {
          type      = "string"
          minLength = 1
        }
        integerProperty = {
          type    = "integer"
          minimum = 1
        }
        arrayProperty = {
          type = "array"
          items = {
            type      = "string"
            minLength = 1
          }
        }
        objectProperty = {
          type = "object"
          properties = {
            stringProperty = {
              type      = "string"
              minLength = 1
            }
          }
        }
      }
    }
  }

  assert {
    condition = output.schema == {
      type        = "object"
      version     = "v1"
      validations = {}
      subItem = {
        boolProperty = {
          type    = "bool"
          version = "v1"
          subItem = null
          validations = {
            default_value     = null
            has_default_value = false
          }
        }
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
        arrayProperty = {
          type    = "array"
          version = "v0"
          subItem = {
            type    = "string"
            version = "v0"
            subItem = null
            validations = {
              minLength = 1
              maxLength = null
            }
          }
          validations = {
            minItems = null
            maxItems = null
          }
        }
        objectProperty = {
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
          }
        }
      }
    }
    error_message = "Error when parsing object with properties."
  }
}
