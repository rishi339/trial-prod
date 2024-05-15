
locals {
  cislz_module_tag = { "cislz-terraform-module" : fileexists("${path.module}/../release.txt") ? "${var.module_name}/${file("${path.module}/../release.txt")}" : "${var.module_name}" }
}

