run "without_items" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/array/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "array"
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "without_minItems_and_maxItems_and_with_bool_items" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/array/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "array"
      items = {
        type = "bool"
      }
    }
  }

  assert {
    condition = {
      type    = output.schema.type
      version = output.schema.version
      subItem = {
        type    = output.schema.subItem.type
        subItem = output.schema.subItem.subItem
      }
      validations = output.schema.validations

      } == {
      type    = "array"
      version = "v0"
      subItem = {
        type    = "bool"
        subItem = null
      }
      validations = {
        minItems = null
        maxItems = null
      }
    }
    error_message = "Error when parsing array with bool item and without minItems and maxItems."
  }
}

run "without_minItems_and_maxItems_and_with_string_items" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/array/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "array"
      items = {
        type      = "string"
        minLength = 1
      }
    }
  }

  assert {
    condition = output.schema == {
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
    error_message = "Error when parsing array with string item and without minItems and maxItems."
  }
}

run "without_minItems_and_maxItems_and_with_integer_items" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/array/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "array"
      items = {
        type    = "integer"
        minimum = 1
      }
    }
  }

  assert {
    condition = output.schema == {
      type    = "array"
      version = "v0"
      subItem = {
        type    = "integer"
        version = "v0"
        subItem = null
        validations = {
          minimum = 1
          maximum = null
        }
      }
      validations = {
        minItems = null
        maxItems = null
      }
    }
    error_message = "Error when parsing array with integer item and without minItems and maxItems."
  }
}

run "without_minItems_and_maxItems_and_with_reduced_object_items" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/array/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "array"
      items = {
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

  assert {
    condition = output.schema == {
      type    = "array"
      version = "v0"
      subItem = {
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
      validations = {
        minItems = null
        maxItems = null
      }
    }
    error_message = "Error when parsing array with reduced_object item and without minItems and maxItems."
  }
}

run "with_minItems" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/array/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type     = "string"
      minItems = 5
      items = {
        type = "bool"
      }
    }
  }

  assert {
    condition = output.schema == {
      type    = "array"
      version = "v0"
      subItem = {
        type    = "bool"
        version = "v1"
        subItem = null
        validations = {
          default_value     = null
          has_default_value = false
        }
      }
      validations = {
        minItems = 5
        maxItems = null
      }
    }
    error_message = "Error when parsing array with minItems and without maxItems."
  }
}

run "with_minLength_and_maxItems" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/array/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type     = "array"
      minItems = 5
      maxItems = 10
      items = {
        type = "bool"
      }
    }
  }

  assert {
    condition = output.schema == {
      type    = "array"
      version = "v0"
      subItem = {
        type    = "bool"
        version = "v1"
        subItem = null
        validations = {
          default_value     = null
          has_default_value = false
        }
      }
      validations = {
        minItems = 5
        maxItems = 10
      }
    }
    error_message = "Error when parsing array with minLength and maxItems."
  }
}

run "with_invalid_minItems_and_maxItems" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/array/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type     = "array"
      minItems = 10
      maxItems = 5
      items = {
        type = "bool"
      }
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_string_minItems" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/array/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type     = "array"
      minItems = "invalid"
      items = {
        type = "bool"
      }
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_string_maxItems" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/array/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type     = "array"
      maxItems = "invalid"
      items = {
        type = "bool"
      }
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_invalid_minItems_value" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/array/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type     = "array"
      minItems = -1
      items = {
        type = "bool"
      }
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_invalid_maxItems_value" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/array/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type     = "array"
      maxItems = 0
      items = {
        type = "bool"
      }
    }
  }

  expect_failures = [
    output.schema,
  ]
}
