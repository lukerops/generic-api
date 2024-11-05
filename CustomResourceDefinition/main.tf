module "v1alpha1" {
  source = "./v1alpha1"
  count  = split("/", var.manifest.apiVersion)[1] == "v1alpha1" ? 1 : 0

  path     = var.path
  manifest = var.manifest
}

module "v1alpha2" {
  source = "./v1alpha2"
  count  = split("/", var.manifest.apiVersion)[1] == "v1alpha2" ? 1 : 0

  path     = var.path
  manifest = var.manifest
}

output "schema" {
  value = one(
    flatten([
      module.v1alpha1[*].schema,
      module.v1alpha2[*].schema
      ]
  ))
}
