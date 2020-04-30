variable a {
    default = "Hello World\n\n\n"
}

locals {
    b = chomp(var.a)
}

output a_value {
    value = var.a
}

output b_value {
    value = local.b
}