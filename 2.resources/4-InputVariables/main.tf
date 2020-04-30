# Basic variable declaration

variable var1 {
    default = "val1"
}

output var1_value {
    value = var.var1
}

# Variable with type definition

## String

variable var2 {
    type = string
    default = "Hello World 123"
}

output var2_value {
    value = var.var2
}

## Number

variable var3 {
    type = number
    default = "123"
}

output var3_value {
    value = var.var3
}

## Boolean

variable var4 {
    type = bool
    default = "0" 
    }

output var4_value {
    value = var.var4
    
}


## List of Strings
variable var5 {
    type = list(string)
    default = ["Hello","India"]
}

output var5_value {
    value = var.var5
}

## List of Numbers
variable var6 {
    type = list(number)
    default = ["123","456"]
}

output var6_value {
    value = var.var6
}

# List of Booleans
variable var7 {
    type = list(bool)
    default = [true,false]
}

output var7_value {
    value = var.var7
}

## Map Variable

variable os {
    type = string
    default = "SUSE Linux Enterprise Server (SLES12-SP2)"
}

variable osAMI {
    type = map
    default = {
    "SUSE Linux Enterprise Server (SLES12-SP1)" = "suse-sles-12-sp1-v????????-hvm-ssd-x86_64"
    "SUSE Linux Enterprise Server (SLES12-SP2)" = "suse-sles-12-sp2-v????????-hvm-ssd-x86_64"
    "SUSE Linux Enterprise Server (SLES12-SP3)" = "suse-sles-12-sp3-v????????-hvm-ssd-x86_64"
    "SUSE Linux Enterprise Server (SLES12-SP4)" = "suse-sles-12-sp4-v????????-hvm-ssd-x86_64"
    "SUSE Linux Enterprise Server (SLES15)" = "suse-sles-15-v????????-hvm-ssd-x86_64"
    "SUSE SLES for SAP Applications (SLES12-SAPSP3)" = "suse-sles-sap-12-sp3-v????????-hvm-ssd-x86_64*"
    "Red Hat Enterprise Linux (RHEL7.2)" = "RHEL-7.2_HVM-????????-x86_64-*-GP2"
    "Red Hat Enterprise Linux (RHEL7.3)" = "RHEL-7.3_HVM-????????-x86_64-*-GP2"
    "Red Hat Enterprise Linux (RHEL7.4)" = "RHEL-7.4_HVM-????????-x86_64-*-GP2"
    "Red Hat Enterprise Linux (RHEL7.5)" = "RHEL-7.5_HVM-????????-x86_64-*-GP2"
    "Red Hat Enterprise Linux (RHEL7.6)" = "RHEL-7.6_HVM-????????-x86_64-*-GP2"
    "Red Hat RHEL for SAP (RHELSAP7.5)" = "SAP-7.5_HVM_GA-????????-x86_64-*-GP2*"
    "Red Hat RHEL for SAP with HANA  and US (RHELHANA7.4)" = "SAPHAE4S-7.4_HVM-????????-x86_64-*-GP2*"
    "Red Hat RHEL for SAP with HANA  and US (RHELHANA7.5)" = "SAPHAEUS-7.5_HVM-????????-x86_64-*-GP2*"
    "Red Hat RHEL for SAP with HANA  and US (RHELHANA7.6)" = "SAP-7.6_E4S_HA_US_HVM-????????-x86_64-*-GP2*"
    "Oracle Linux version 6.9" = "OL6.9-x86_64-HVM-????-??-??"
    "Oracle Linux version 6.10" = "OL6.10-x86_64-HVM-????-??-??"
    "Oracle Linux version 7.4" = "OL7.4-x86_64-HVM-????-??-??"
    "Oracle Linux version 7.5" = "OL7.5-x86_64-HVM-????-??-??"
    "Oracle Linux version 7.6" = "OL7.6-x86_64-HVM-????-??-??"
    "Windows Server 2008 R2" = "Windows_Server-2008-R2_SP1-English-64Bit-Base-????.??.??"
    "Windows Server 2012" = "Windows_Server-2012-RTM-English-64Bit-Base-????.??.??"
    "Windows Server 2012 R2" = "Windows_Server-2012-R2*-English-64Bit-Base-????.??.??"
    "Windows Server 2016" = "Windows_Server-2016*-English-*-Base-????.??.??"
    }
}


output ami-regex {
    value = lookup(var.osAMI,var.os)
}

# Object Example
################

variable disks {
    type  = list(object({
    Drive = string
    DiskSize = number
    }))
    default = [ {Drive = "xvdf" , DiskSize = 500},{Drive = "xvdg" , DiskSize = 100} ]

}

output disks_value {
    value = var.disks
}

## Custom Validation Example
#############################
terraform {
  required_version = "~> 0.12"
  experiments      = [variable_validation]
}

variable "image_id" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."
  
  
  validation {
    condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}

output image_id_value {
    value = var.image_id
}
