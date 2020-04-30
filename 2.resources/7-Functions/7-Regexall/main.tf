variable a {
    default = "Hello Wipro, Good day Wipro"
}

locals {
    b = regexall("Digital", var.a)
}

output b_value {
    value = local.b
}