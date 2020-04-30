variable a {
    type = list
    default = [ "Wipro", "Good", "day", "Wipro" ]
}


locals {
    b = contains(var.a,"Digital")
}

output b_value {
    value = local.b
}
