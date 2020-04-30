variable a {
    type = list
    default = [ "Wipro", "Good", "day", "Wipro" ]
}


locals {
    b = distinct(var.a)
}

output b_value {
    value = local.b
}
