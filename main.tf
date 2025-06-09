
resource "random_password" "password" {
  count  = var.password == null ? 1 : 0
  length = 20
}

locals {
  password = try(random_password.password[0].result, var.password)
}