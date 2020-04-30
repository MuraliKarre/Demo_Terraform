variable a {
    default = "Wipro, Good day Wipro"
}

variable f {
    default = "  Wipro   "
}

locals {
    b = trim(var.a,"Wipro")
    c = trimprefix(var.a,"Wipro")
    d = trimsuffix(var.a,"Wipro")
    e = trimspace(var.f)
}

output b_value {
    value = local.b
}

output c_value {
    value = local.c
}

output d_value {
    value = local.d
}

output e_value {
    value = local.e
}