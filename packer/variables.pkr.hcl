# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "vsphere_server" {
  type    = string
  default = "10.10.10.5"
}

variable "vsphere_user" {
  type    = string
  default = "administrator@vsphere.local"
}

variable "vsphere_password" {
  type    = string
  default = "Admin@123"
}

variable "datacenter" {
  type    = string
  default = "Datacenter"
}

variable "cluster" {
  type    = string
  default = "Region01"
}

variable "datastore" {
  type    = string
  default = "datastore1"
}

variable "network_name" {
  type    = string
  default = "VM Network"
}