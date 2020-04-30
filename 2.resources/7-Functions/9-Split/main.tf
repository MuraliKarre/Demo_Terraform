variable a {
    default = "Hello Wipro, Good day Wipro"
}

locals {
    b = split(",",var.a)
}

output b_value {
    value = local.b[1]
}