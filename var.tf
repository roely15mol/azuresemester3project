variable "resource_group_name" {
  description = "Name of the resource group in which the resources will be created"
  default     = "myResourceGroup"
}

variable "location" {
  default     = "westeurope"
  description = "Location where resources will be created"
}

variable "tags" {
  description = "Map of the tags to use for the resources that are deployed"
  type        = map(string)
  default = {
    environment = "codelab"
  }
}

variable "application_port" {
   description = "Port that you want to expose to the external load balancer"
   default     = 80
}

variable "admin_user" {
   description = "User name to use as the admin account on the VMs that will be part of the VM scale set"
   default     = "azureuser"
}

variable "admin_password" {
   description = "Default password for admin account"
   default = "Testww@123"
}

variable "mysql_admin_user" {
    description = "default password for sql admin user"
    default = "dbadmin"
}

variable "mysql_admin_password" {
    description = "Default password for sql admin user"
    default = "Testww@123"
}