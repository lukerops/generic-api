run "can_parse_crd_v1alpha2" {
  command = plan
  module {
    source = "./CustomResourceDefinition"
  }

  variables {
    path = "./tests/fixtures/user.gcp.iam.crd_with_default_value_boolean_v1alpha2.yml"
    manifest = {
      "apiVersion" = "tf-gapi.lukerops.com/v1alpha2"
      "kind"       = "CustomResourceDefinition"
      "metadata" = {
        "name" = "user.gcp.iam"
      }
      "spec" = {
        "group" = "gcp.iam"
        "kind"  = "User"
        "versions" = [
          {
            "name" = "v1alpha2"
            "specSchema" = {
              "properties" = {
                "email" = {
                  "type" = "string"
                }
              }
              "type" = "object"
            }
          },
        ]
      }
    }
  }

  assert {
    condition     = output.schema != null
    error_message = "CRD v1alpha2 não foi parseado"
  }

  assert {
    condition = {
      path  = output.schema.path
      name  = output.schema.name
      group = output.schema.group
      kind  = output.schema.kind
      } == {
      path  = "./tests/fixtures/user.gcp.iam.crd_with_default_value_boolean_v1alpha2.yml"
      name  = "user.gcp.iam"
      group = "gcp.iam"
      kind  = "User"
    }
    error_message = "CRD v1alpha2 não teve dos os campos básicos parseados"
  }
}

