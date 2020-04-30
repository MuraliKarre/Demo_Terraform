variable a {
    default = "Hello" 
}

variable b {
    default = "World!!!"
}

locals {
    c = join(" ",[var.a , var.b])
}

output c_value {
    value = local.c
}