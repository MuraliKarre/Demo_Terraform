variable var1 {
    default = "Hello"
}

variable var2 {
    type = string
}


locals {
    var3 = join(" ",[var.var1 , var.var2])
    var4 = join("+",[var.var1,var.var2])
}

output var3_value {
    value = local.var3
}

output var4_value {
    value = local.var4
}
