variable a {
    type = list(string)
    default = ["Hello","Wipro"]
}

variable b {
    type = list(string)
    default = ["Welcome to", "Terraform Training"]
}

locals {
    c = concat(var.a,var.b)
}

output c_value {
    value = local.c
}