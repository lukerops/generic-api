run "without_items" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/reduced_array"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "reduces_array"
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "without_minItems_and_maxItems_and_with_bool_items" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/reduced_array"
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
    condition = output.schema == {
      type    = "reduced_array"
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
        minItems = null
        maxItems = null
      }
    }
    error_message = "Error when parsing reduced_array with bool item and without minItems and maxItems."
  }
}

run "without_minItems_and_maxItems_and_with_string_items" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/reduced_array"
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
      type    = "reduced_array"
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
    error_message = "Error when parsing reduced_array with string item and without minItems and maxItems."
  }
}

run "without_minItems_and_maxItems_and_with_integer_items" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/reduced_array"
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
      type    = "reduced_array"
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
    error_message = "Error when parsing reduced_array with integer item and without minItems and maxItems."
  }
}

run "with_minItems" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/reduced_array"
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
      type    = "reduced_array"
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
    error_message = "Error when parsing reduced_array with minItems and without maxItems."
  }
}

run "with_minLength_and_maxItems" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/reduced_array"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type     = "reduces_array"
      minItems = 5
      maxItems = 10
      items = {
        type = "bool"
      }
    }
  }

  assert {
    condition = output.schema == {
      type    = "reduced_array"
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
    error_message = "Error when parsing reduced_array with minLength and maxItems."
  }
}

run "with_invalid_minItems_and_maxItems" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/reduced_array"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type     = "reduces_array"
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
    source = "./CustomResourceDefinition/v1alpha2/reduced_array"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type     = "reduces_array"
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
    source = "./CustomResourceDefinition/v1alpha2/reduced_array"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type     = "reduces_array"
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
    source = "./CustomResourceDefinition/v1alpha2/reduced_array"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type     = "reduces_array"
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
    source = "./CustomResourceDefinition/v1alpha2/reduced_array"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type     = "reduces_array"
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
