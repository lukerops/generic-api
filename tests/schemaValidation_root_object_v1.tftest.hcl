run "missing_value" {
  command = plan
  module {
    source = "./schemaValidation/root_object/v1/"
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
    manifest = {
    }
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_invalid_value" {
  command = plan
  module {
    source = "./schemaValidation/root_object/v1/"
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


run "absent_boolean_with_default_value_on_root_object" {

  command = plan

  module {
    source = "./schemaValidation/root_object/v1/"
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
    condition = {
      active = output.resource.active
      } == {
      active = true
    }
    error_message = "Error: Não preencheu corretamente valor de vampo bool/v1 com default value"
  }

}


run "present_boolean_with_default_value_on_root_object" {

  command = plan

  module {
    source = "./schemaValidation/root_object/v1/"
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
      active = null
    }
  }

  assert {
    condition = {
      active = output.resource.active
      } == {
      active = true
    }
    error_message = "Error: Não preencheu corretamente valor de vampo bool/v1 com default value"
  }

}

run "boolean_with_default_value_on_object_inside_root_object" {

  command = plan

  module {
    source = "./schemaValidation/root_object/v1/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "root_object"
      version     = "v1"
      validations = {}
      subItem = {
        dados = {
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
      }
    }
    manifest = {
      dados = {
        # Está comentado para simular um manifesto sem a presença desse campo
        #active = null
      }
    }
  }

  assert {
    condition     = output.resource.dados.active == true
    error_message = <<-EOT
    Error: Não preencheu corretamente valor de vampo bool/v1 com default value
EOT
  }
}

run "boolean_with_default_value_on_reduced_object_inside_object_inside_root_object" {

  command = plan

  module {
    source = "./schemaValidation/root_object/v1/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "root_object"
      version     = "v1"
      validations = {}
      subItem = {
        dados = {
          type        = "object"
          version     = "v1"
          validations = {}
          subItem = {
            bool_val = {
              type        = "reduced_object"
              version     = "v1"
              validations = {}
              subItem = {
                active = {
                  type    = "bool"
                  version = "v1"
                  validations = {
                    default_value     = true
                    has_default_value = true
                  }
                }
              }
            }
          }
        }

      }
    }
    manifest = {
      dados = {
        bool_val = {
          #active = null
        }
      }
    }
  }

  assert {
    condition     = output.resource.dados.bool_val.active == true
    error_message = <<-EOT
    Error: Não preencheu corretamente valor de vampo bool/v1 com default value
EOT
  }
}


run "manifest_with_boolean_v1_no_default_value" {
  command = plan

  module {
    source = "./schemaValidation/root_object/v1/"
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
            default_value     = null
            has_default_value = false
          }
        }
      }
    }
    manifest = {
      active = true
    }
  }

  assert {
    condition = {
      active = output.resource.active
      } == {
      active = true
    }
    error_message = "Error: Não preencheui corretamente valor de vampo bool/v1"
  }

}

run "with_valid_value" {
  command = plan
  module {
    source = "./schemaValidation/root_object/v1/"
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
          type    = "bool"
          version = "v1"
          subItem = null
          validations = {
            default_value     = null
            has_default_value = false
          }
        }
        objectProperty = {
          type        = "object"
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
          }
        }
      }
    }
    manifest = {
      stringProperty  = "test"
      integerProperty = 1
      boolProperty    = true
      objectProperty = {
        stringProperty = "test"
      }
    }
  }

  assert {
    condition = output.resource == {
      stringProperty  = "test"
      integerProperty = 1
      boolProperty    = true
      objectProperty = {
        stringProperty = "test"
      }
    }
    error_message = "Error when validating object."
  }
}
