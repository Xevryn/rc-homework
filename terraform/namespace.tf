provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "rc_homework" {
  metadata {
    name = "rc-homework"
  }
}
