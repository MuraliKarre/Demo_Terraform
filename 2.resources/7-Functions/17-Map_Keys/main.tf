variable a {
    type = map
    default = { CompanyName: "Wipro", Business: "ITServices", Location: "Bangalore" } 
}


locals {
    b = keys(var.a)
}

output b_value {
    value = local.b
}

output map {
    value = var.a
}
