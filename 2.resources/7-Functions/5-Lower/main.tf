variable a {
    default = "HELLO"
}

locals {
    b = lower(var.a)
}

output b_value {
    value = local.b
}