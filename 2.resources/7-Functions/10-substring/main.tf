variable a {
    default = "Hello Wipro, Good day Wipro"
}

locals {
    b = substr(var.a,6,5)
}

output b_value {
    value = local.b
}