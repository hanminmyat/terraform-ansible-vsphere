# VMware vCenter connection #

variable "vsphere_server" {
  description = "vSphere server"
  type        = string
}

variable "vsphere_user" {
  description = "vSphere username"
  type        = string
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
  sensitive   = true
}

variable "vsphere_datacenter" {
  description = "vSphere data center"
  type        = string
}

variable "vsphere_cluster" {
  description = "vSphere cluster"
  type        = string
}

variable "vsphere-template-folder" {
type = string
description = "Template folder"
default = "Templates"
}

# VMware vSphere virtual machine #

variable "vm-count" {
type = string
description = "Number of VM"
default     =  1
}
variable "vm-name-prefix" {
type = string
description = "Name of VM prefix"
default     =  "playtf"
}

variable "datastore" {
  description = "vSphere datastore"
  type        = string
}

variable "network_name" {
  description = "vSphere network name"
  type        = string
}

variable "vm-cpu" {
type = string
description = "Number of vCPU for the vSphere virtual machines"
default = "2"
}

variable "vm-ram" {
type = string
description = "Amount of RAM for the vSphere virtual machines (example: 2048)"
}

variable "vm-name" {
type = string
description = "The name of the vSphere virtual machines and the hostname of the machine"
}

variable "vm-guest-id" {
type = string
description = "The ID of virtual machines operating system"
}

variable "vm-template-name" {
type = string
description = "The template to clone to create the VM"
}

variable "vm-host-count" {
  type = string
  default = 30
}

variable "vm-domain" {
type = string
description = "Linux virtual machine domain name for the machine. This, along with host_name, make up the FQDN of the virtual machine"
default = ""
}