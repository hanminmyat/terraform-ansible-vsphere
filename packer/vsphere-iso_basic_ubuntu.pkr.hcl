# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

packer {
  required_plugins {
    vsphere = {
      version = ">= 1.2.3"
      source  = "github.com/hashicorp/vsphere"
    }
  }
}

source "vsphere-iso" "this" {
  vcenter_server      = var.vsphere_server
  username            = var.vsphere_user
  password            = var.vsphere_password
  datacenter          = var.datacenter
  cluster             = var.cluster
  insecure_connection = true

  vm_name       = "edu-ubuntu"
  guest_os_type = "ubuntu64Guest"

  CPUs            = 2
  RAM             = 2048
  RAM_reserve_all = true

  ssh_username = "ubuntu"
  ssh_password = "ubuntu"
  ssh_timeout  = "30m"

  /* Uncomment when running on vcsim
  ssh_host     = "127.0.0.1"
  ssh_port     = 2222

  configuration_parameters = {
    "RUN.container" : "lscr.io/linuxserver/openssh-server:latest"
    "RUN.mountdmi" : "false"
    "RUN.port.2222" : "2222"
    "RUN.env.USER_NAME" : "ubuntu"
    "RUN.env.USER_PASSWORD" : "ubuntu"
    "RUN.env.PASSWORD_ACCESS" : "true"
  }
  */

  disk_controller_type = ["pvscsi"]
  datastore            = var.datastore
  storage {
    disk_size             = 16384
    disk_thin_provisioned = true
  }

  iso_paths = ["[datastore1] ISO/ubuntu-22.04.3-desktop-amd64.iso"]

  network_adapters {
    network = var.network_name
  }

  cd_files = ["./meta-data", "./user-data" ,"./preseed.cfg"]
  cd_label = "cidata"

  boot_command = [
  "<esc><esc><enter><wait>",
  "auto=true ",
  "priority=critical ",
  "preseed/file=/cdrom/preseed.cfg",
  "debian-installer=en_US auto locale=en_US kbd-chooser/method=us ",
  "hostname=ubuntu",
  "fb=false debconf/frontend=noninteractive ",
  "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA ",
  "keyboard-configuration/variant=USA console-setup/ask_detect=false ",
  "initrd=/install/initrd.gz -- <enter>"
]

  configuration_parameters = {
    "network" : "10.10.10.24"
    "subnet_mask"       = "255.255.255.0"
    "default_gateway"   = "10.10.10.1"
  }

}

build {
  sources = [
    "source.vsphere-iso.this"
  ]

  provisioner "shell-local" {
    inline = ["echo the address is: $PACKER_HTTP_ADDR and build name is: $PACKER_BUILD_NAME"]
  }
}
