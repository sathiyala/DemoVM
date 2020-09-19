variable "rgname" {
    description = "resource grouop name"
    default     = "RG_Terravms"
}

variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
  default     = "centralindia"
}

variable "vnet_name" {
     description = "name for vnet"
     default     = "vnet"
}

variable "address_space" {
     default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
     default     = "subnet"
}

variable "address_prefix" {
      default     = "10.0.1.0/24"
}


variable "numbercount" {
    type 	  = number
    default       = 4
} 

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_D1_v2"
}

variable "image_publisher" {
  description = "name of the publisher of the image (az vm image list)"
  default     = "MicrosoftWindowsServer"
}

variable "image_offer" {
  description = "the name of the offer (az vm image list)"
  default     = "WindowsServer"
}

variable "image_sku" {
  description = "image sku to apply (az vm image list)"
  default     = "2012-R2-Datacenter"
}

variable "image_version" {
  description = "version of the image to apply (az vm image list)"
  default     = "latest"
}

variable "hostname" {
  description = "VM name referenced also in storage-related names."
  default     = "hostname"
}

variable "admin_username" {
  description = "administrator user name"
  default     = "vmadmin"
}

variable "admin_password" {
  description = "administrator password (recommended to disable password auth)"
  default     = "Mylabs@123456"
}


