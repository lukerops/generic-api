run "without_minimum_and_maximum" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/integer"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "integer"
    }
  }

  assert {
    condition = output.schema == {
      type    = "integer"
      version = "v0"
      subItem = null
      validations = {
        minimum = null
        maximum = null
      }
    }
    error_message = "Error when parsing integer field without minimum and maximum."
  }
}

run "with_minimum" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/integer"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type    = "integer"
      minimum = 5
    }
  }

  assert {
    condition = output.schema == {
      type    = "integer"
      version = "v0"
      subItem = null
      validations = {
        minimum = 5
        maximum = null
      }
    }
    error_message = "Error when parsing integer field with minimum and without maximum."
  }
}

run "with_minimum_and_maximum" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/integer"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type    = "integer"
      minimum = 5
      maximum = 10
    }
  }

  assert {
    condition = output.schema == {
      type    = "integer"
      version = "v0"
      subItem = null
      validations = {
        minimum = 5
        maximum = 10
      }
    }
    error_message = "Error when parsing integer field with minimum and maximum."
  }
}

run "with_invalid_minimum_and_maximum" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/integer"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type    = "integer"
      minimum = 10
      maximum = 5
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_string_minimum" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/integer"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type    = "integer"
      minimum = "invalid"
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_string_maximum" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/integer"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type    = "integer"
      maximum = "invalid"
    }
  }

  expect_failures = [
    output.schema,
  ]
}
