run "missing_name" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/version/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0]"
    manifest      = {}
  }

  expect_failures = [
    output.schema,
  ]
}

run "missing_specSchema" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/version/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0]"
    manifest = {
      name = "test"
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_specSchema" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha2/version/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0]"
    manifest = {
      name = "test"
      specSchema = {
        type = "object"
        properties = {
          test = {
            type = "string"
          }
        }
      }
    }
  }

  assert {
    condition = output.schema == {
      name       = "test"
      enabled    = true
      deprecated = false
      schema = {
        type        = "root_object"
        version     = "v1"
        validations = {}
        subItem = {
          test = {
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
    }
    error_message = "Error when parsing version with specSchema."
  }
}
