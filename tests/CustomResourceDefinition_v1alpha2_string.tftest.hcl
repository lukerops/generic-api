run "without_minLength_and_maxLength" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/string"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "string"
    }
  }

  assert {
    condition = output.schema == {
      type    = "string"
      version = "v0"
      subItem = null
      validations = {
        minLength = null
        maxLength = null
      }
    }
    error_message = "Error when parsing string field without minLength and maxLength."
  }
}

run "with_minLength" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/string"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type      = "string"
      minLength = 5
    }
  }

  assert {
    condition = output.schema == {
      type    = "string"
      version = "v0"
      subItem = null
      validations = {
        minLength = 5
        maxLength = null
      }
    }
    error_message = "Error when parsing string field with minLength and without maxLength."
  }
}

run "with_minLength_and_maxLength" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/string"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type      = "string"
      minLength = 5
      maxLength = 10
    }
  }

  assert {
    condition = output.schema == {
      type    = "string"
      version = "v0"
      subItem = null
      validations = {
        minLength = 5
        maxLength = 10
      }
    }
    error_message = "Error when parsing string field with minLength and maxLength."
  }
}

run "with_invalid_minLength_and_maxLength" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/string"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type      = "string"
      minLength = 10
      maxLength = 5
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_string_minLength" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/string"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type      = "string"
      minLength = "invalid"
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_string_maxLength" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/string"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type      = "string"
      maxLength = "invalid"
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_invalid_minLength_value" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/string"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type      = "string"
      minLength = -1
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_invalid_maxLength_value" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/string"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type      = "string"
      maxLength = -1
    }
  }

  expect_failures = [
    output.schema,
  ]
}
