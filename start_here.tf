module "vpc" {
  source = "./modules/vpc"
}

module "eks_cluster" {
  source = "./modules/cluster"

  depends_on = [module.vpc]
}


resource "kubernetes_namespace" "nginx" {
  metadata {
    name = "nginx"
  }

  depends_on = [
    module.eks_cluster
  ]
}

resource "helm_release" "nginx" {
  name        = "nginx"
  description = "Sample nginx Application. You will create helm chart"
  repository  = path.module
  chart       = "app"
  namespace   = kubernetes_namespace.nginx.metadata[0].name

  dynamic "set" {
    for_each = { for var in local.nginx_variables : var.name => var }

    content {
      name  = set.value.name
      value = set.value.value
      type  = try(set.value.type, "string")
    }
  }

  depends_on = [helm_release.operator]
}
