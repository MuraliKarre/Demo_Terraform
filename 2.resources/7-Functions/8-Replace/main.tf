variable a {
    default = "Hello Wipro, Good day Wipro"
}

locals {
    b = replace(var.a,"Digital","World")
}

output b_value {
    value = local.b
}