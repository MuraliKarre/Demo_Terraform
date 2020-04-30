variable list {
     type = list(string)
      default = ["hello","india"]
}

locals {
     upperlist = [for s in var.list : upper(s)]
     upperobject = {
       for s in var.list: 
          s => upper(s)
     }
}     

output ulist {
    value = local.upperlist    
}

output uobject {
    value = local.upperobject
}
