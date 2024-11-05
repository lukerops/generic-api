run "without_properties" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/reduced_object/"
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
    source = "./CustomResourceDefinition/v1alpha2/reduced_object/"
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
    source = "./CustomResourceDefinition/v1alpha2/reduced_object/"
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
    source = "./CustomResourceDefinition/v1alpha2/reduced_object/"
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
    source = "./CustomResourceDefinition/v1alpha2/reduced_object/"
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
          type = "string"
        }
        integerProperty = {
          type = "integer"
        }
        arrayProperty = {
          type = "array"
          items = {
            type = "string"
          }
        }
      }
    }
  }

  assert {
    condition = output.schema == {
      type        = "reduced_object"
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
            minLength = null
            maxLength = null
          }
        }
        integerProperty = {
          type    = "integer"
          version = "v0"
          subItem = null
          validations = {
            minimum = null
            maximum = null
          }
        }
        arrayProperty = {
          type    = "reduced_array"
          version = "v0"
          subItem = {
            type    = "string"
            version = "v0"
            subItem = null
            validations = {
              minLength = null
              maxLength = null
            }
          }
          validations = {
            minItems = null
            maxItems = null
          }
        }
      }
    }
    error_message = "Error when parsing reduced_object with properties."
  }
}
