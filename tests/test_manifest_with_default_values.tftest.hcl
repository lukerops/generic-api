run "manifest_with_default_value_boolean_absent_fields" {
  # Manifestos onde nenhum campo default está presente no yaml
  # dessa forma todos os campos serão preenchidos com seus respectivos valores
  # default
  command = plan

  variables {
    yamls = [
      "./tests/fixtures/user.gcp.iam.crd_with_default_value_boolean_v1alpha2.yml",
      "./tests/fixtures/user.gcp.iam.manifest_with_default_value_boolean_using_crd_v1alpha2.yml"
    ]
  }

  assert {
    condition     = output.resources["gcp.iam"]["User"]["user-teste"].spec.active == false
    error_message = "Default value boolean não usado"
  }

  assert {
    condition     = output.resources["gcp.iam"]["User"]["user-teste"].spec.endereco.active == true
    error_message = "Default value boolean não usado"
  }

  assert {
    condition     = output.resources["gcp.iam"]["User"]["user-teste"].spec.endereco.inner_object.active == false
    error_message = "Default value boolean não usado"
  }


}


run "manifest_with_default_value_boolean_present_fields" {
  # Manifestos onde todos os campos com default estão presentes no yaml
  # dessa forma todos os campos serão preenchidos com seus respectivos valores
  # e os valores default não serão usados
  command = plan

  variables {
    yamls = [
      "./tests/fixtures/user.gcp.iam.crd_with_default_value_boolean_v1alpha2.yml",
      "./tests/fixtures/user.gcp.iam.manifest_with_default_value_boolean_using_crd_v1alpha2_version_v1alpha3.yml"
    ]
  }


  assert {
    condition     = output.resources["gcp.iam"]["User"]["user-teste"].spec.active == true
    error_message = "Default value boolean não usado"
  }

  assert {
    condition     = output.resources["gcp.iam"]["User"]["user-teste"].spec.endereco.active == true
    error_message = "Default value boolean não usado"
  }

  assert {
    condition     = output.resources["gcp.iam"]["User"]["user-teste"].spec.endereco.inner_object.active == true
    error_message = "Default value boolean não usado"
  }

}
