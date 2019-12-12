variable "resource_group" {
  type        = string
  description = "Resource group to deploy resources in"
  default = "pfsense-test"  
}

variable "admin_username" {
  type        = string
  description = "Admin Username"
  default = "pfsense-user"
}

variable "admin_password" {
  type        = string
  description = "Admin Password"
  default = "mysuperpassword"
}

variable "vm_name" {
  type        = string
  description = "VM name"
  default = "pfsense-test"  
}

variable "primary_region" {
  type        = string
  description = "Primary region the implementation should be applied to"
  default = "southafricanorth" ##southafricanorth
}

variable "region_dns" {
  type        = string
  description = "DNS name"
  default = "justpulsingaround"
}

variable "virtual_machine_size" {
  type = string
  description = "Size of Virtual Machine"
  default = "Basic_A0" 
}

variable "os_disk_type" {
  type = string
  description = "Type of OS disk"
  default = "Standard_LRS"
}



# This should not change
variable "image_publisher" {
  type = string
  default = "netgate"
}

variable "image_offer" {
  type = string
  default = "netgate-pfsense-azure-fw-vpn-router"
}

variable "image_sku" {
  type = string
  default = "netgate-pfsense-azure-243"
}

variable "image_version" {
  type = string
  default = "2.4.431"
}