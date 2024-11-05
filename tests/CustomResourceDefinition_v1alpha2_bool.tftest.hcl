run "with_default_false" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/bool"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type    = "bool"
      default = false
    }
  }

  assert {
    condition = output.schema == {
      type    = "bool"
      version = "v1"
      subItem = null
      validations = {
        default_value     = false
        has_default_value = true
      }
    }
    error_message = "Error when parsing bool field with default=false"
  }
}


run "with_default_true" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/bool"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type    = "bool"
      default = true
    }
  }

  assert {
    condition = output.schema == {
      type    = "bool"
      version = "v1"
      subItem = null
      validations = {
        default_value     = true
        has_default_value = true
      }
    }
    error_message = "Error when parsing bool field with default=true"
  }
}

run "without_default_value" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/bool"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "bool"
    }
 }

  assert {
    condition = output.schema == {
      type    = "bool"
      version = "v1"
      subItem = null
      validations = {
        default_value     = null
        has_default_value = false
      }
    }
    error_message = "Error when parsing bool field without default value"
  }
}

run "with_null_default_value" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/bool"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "bool"
      default = null
    }
  }

  expect_failures = [
      output.schema
  ]
}
