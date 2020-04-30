variable a {
    default = ( "Good Day Wipro123" )
}

variable e {
    default = ("123")
}

locals {
    b = tolist(["a", "b", "c"])
    c = tostring(var.a)
    d = tonumber(var.e)
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

