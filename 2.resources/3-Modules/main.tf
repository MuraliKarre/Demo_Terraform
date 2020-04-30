module "datasource" {
  source = "./datasource"

  region = var.region
}

output datasource_AMI_ID {
  value = module.datasource.AMI_ID
}

output datasource_AMI_Name {
  value = module.datasource.AMI_NAME
}
