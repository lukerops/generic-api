run "can_validate_root_object_v0" {
  command = plan
  module {
    source = "./schemaValidation/root_object"
  }
  variables {
    metadata_name = "test-root_object"
    path          = "."
    field_path    = "spec.dados"
    manifest = {
      ativo = true
      nome  = "Nome"
    }
    schema = {
      type        = "object"
      version     = "v0"
      validations = {}
      subItem = {
        nome = {
          type    = "string"
          version = "v0"
          subItem = null
          validations = {
            minLength = null
            maxLength = null
          }
        }
        ativo = {
          type        = "bool"
          version     = "v0"
          subItem     = null
          validations = {}
        }
      }
    }
  }

  assert {
    condition = output.resource == {
      ativo = true
      nome  = "Nome"
    }
    error_message = "Não validou um root_object v0 corretamente"

  }
}

run "can_validate_root_object_v1" {
  command = plan
  module {
    source = "./schemaValidation/root_object"
  }
  variables {
    metadata_name = "test-root_object"
    path          = "."
    field_path    = "spec.dados"
    manifest = {
      ativo = true
      nome  = "Nome"
    }
    schema = {
      type        = "object"
      version     = "v1"
      validations = {}
      subItem = {
        nome = {
          type    = "string"
          version = "v0"
          subItem = null
          validations = {
            minLength = null
            maxLength = null
          }
        }
        ativo = {
          type        = "bool"
          version     = "v0"
          subItem     = null
          validations = {}
        }
      }
    }
  }

  assert {
    condition = output.resource == {
      ativo = true
      nome  = "Nome"
    }
    error_message = "Não validou um root_object v1 corretamente"

  }
}
