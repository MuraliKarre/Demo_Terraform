variable a {
    type = map
    default = { CompanyName: "Wipro", Business: "ITServices", Location: "Bangalore" } 
}


locals {
    b = values(var.a)
}

output b_value {
    value = local.b
}
