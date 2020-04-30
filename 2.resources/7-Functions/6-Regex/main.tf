variable a {
    default = "Hello Wipro, Good day Wipro"
}

locals {
    b = regex("Wipro", var.a)
}

output b_value {
    value = local.b
}