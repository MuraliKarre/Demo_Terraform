variable "region" {}
variable "vpcinfo" {
    type  = list(object({
    vpcName  = string
    vpcIPAddress = string
    }))
}
variable "PrvSubnets" {
    type  = list(object({
    prvsubnetip  = string
    prvsubnetname = string
    }))
}
variable "PubSubnets" {
    type  = list(object({
    pubsubnetip  = string
    pubsubnetname = string
    }))
}
variable "NATGW" {}

data "aws_availability_zones" "AZS" {
   state = "available"
}

locals {
  AZNames = chunklist(data.aws_availability_zones.AZS.names,2)[0]
  PvtSubcount = length(var.PrvSubnets) 
  PubSubcount = length(var.PubSubnets)
 
 AZS = {
   PrvSubnets = {    
      PvtAZS = tonumber(length(local.AZNames)) >= tonumber(local.PvtSubcount) ? local.AZNames : concat(local.AZNames,local.AZNames,local.AZNames,local.AZNames)
    },
   PubSubnets = {
      PubAZS = tonumber(length(local.AZNames)) >= tonumber(local.PubSubcount) ? local.AZNames : concat(local.AZNames,local.AZNames,local.AZNames,local.AZNames)
   }
 }
}
