variable vpc {}
variable region {}
variable iam_instance_profile {}
variable ec2subnets {
  type = list(string)
}
variable elbsubnets {
  type = list(string)
}
variable serverName {}
variable operatingSystem {}
variable vmSize {}
variable disks {
    type  = list(object({
    Drive = string
    DirPath = string
    DiskSize = number
    }))
    
}
variable osDiskStorageType {}
variable publicKey {}

# Static Variables
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
    }
}

variable family {
    type = map 
    default = {
    "SUSE Linux Enterprise Server (SLES12-SP1)" = "Linux"
    "SUSE Linux Enterprise Server (SLES12-SP2)" = "Linux"
    "SUSE Linux Enterprise Server (SLES12-SP3)" = "Linux"
    "SUSE Linux Enterprise Server (SLES12-SP4)" = "Linux"
    "SUSE Linux Enterprise Server (SLES15)" = "Linux"
    "SUSE SLES for SAP Applications (SLES12-SAPSP3)" = "Linux"    
    "Red Hat Enterprise Linux (RHEL7.2)" = "Linux"
    "Red Hat Enterprise Linux (RHEL7.3)" = "Linux"
    "Red Hat Enterprise Linux (RHEL7.4)" = "Linux"
    "Red Hat Enterprise Linux (RHEL7.5)" = "Linux"
    "Red Hat Enterprise Linux (RHEL7.6)" = "Linux"
    "Red Hat RHEL for SAP (RHELSAP7.5)" = "Linux"
    "Red Hat RHEL for SAP with HANA  and US (RHELHANA7.4)" = "Linux"
    "Red Hat RHEL for SAP with HANA  and US (RHELHANA7.5)" = "Linux"
    "Red Hat RHEL for SAP with HANA  and US (RHELHANA7.6)" = "Linux"
    "Oracle Linux version 6.9" = "Linux"
    "Oracle Linux version 6.10" = "Linux"
    "Oracle Linux version 7.4" = "Linux"
    "Oracle Linux version 7.5" = "Linux"
    "Oracle Linux version 7.6" = "Linux"
    }
}

variable storageId {
    type = map
    default = {
        "General Purpose SSD (gp2)" = "gp2"
        "Provisioned IOPS SSD (io1)" = "io1"
        "Throughput Optimized HDD" =  "st1"
        "Cold HDD" = "sc1"
    }    
}



# Interopolated Variables 
locals {
  platform = lookup (var.family, var.operatingSystem)
  
  DiskConfig = {
    Linux =   {
        RamSize = 1
        SwapDrv = var.disks[length(var.disks) - 1].Drive
        Drives = [
            for drive in var.disks[*]:
            join("-", [drive.Drive,"ext4",drive.DirPath ])
        ]
        }  
    }    
    
    firewallRules = {
      Linux = {
             inboundRules = join("",["TCP-22,","TCP-80"])
             outboundRules = join("",["TCP-80,","TCP-443"])
           }
        }
    
    commonVars = {
      Linux = {
        drives = replace(replace(replace(tostring(jsonencode(local.DiskConfig[local.platform].Drives)),"[",""),"]",""),"\"","")
        directories= replace(replace(replace(tostring(jsonencode(var.disks[*].DirPath)),"[",""),"]",""),"\"","")
        SwapSize=join("",[floor(trimspace(local.DiskConfig[local.platform].RamSize)*2*99/100),"G"])
        instanceType = var.vmSize
        inboundList = split(",", local.firewallRules[local.platform].inboundRules)
        outboundList =  split(",", local.firewallRules[local.platform].outboundRules) 
        }
      
      
      }
    
    commonVMSetupExtension = {
      Linux = {
        scriptArgs = join(" ",[ local.commonVars[local.platform].drives, local.commonVars[local.platform].directories,local.firewallRules[local.platform].inboundRules,local.firewallRules[local.platform].outboundRules,local.DiskConfig[local.platform].SwapDrv,local.commonVars[local.platform].SwapSize,var.serverName])      
      }
    }   
 }