# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.network_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name          = "/${var.vsphere_datacenter}/vm/${var.vsphere-template-folder}/${var.vm-template-name}"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# Create VMs

resource "vsphere_virtual_machine" "vm" {
  count            = var.vm-count
  name             = "${var.vm-name}-${count.index + 1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  guest_id         = "centos7_64Guest"

  num_cpus = var.vm-cpu
  memory   = var.vm-ram

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label            = "${var.vm-name}-${count.index + 1}-disk"
    thin_provisioned = true
    size             = 25
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      timeout = 0

      linux_options {
        host_name = "node-${count.index + 1}"
        domain    = var.vm-domain
      }

      network_interface {
        ipv4_address    = "10.10.10.${30 + count.index}" 
        ipv4_netmask    = 24
        dns_server_list = ["8.8.8.8,8.8.4.4"] 
      }

      ipv4_gateway = "10.10.10.1"
    }
  }

  provisioner "remote-exec" {
    inline = [
      # Your existing remote-exec commands

      # For example, to update the mirror in CentOS:
      "sudo sed -i 's/mirror.centos.org/mirror.example.com/' /etc/yum.repos.d/CentOS-Base.repo",
      
      # Additional configurations can be added here
    ]

    connection {
      type        = "ssh"
      host        = self.network_interface[count.index].ipv4_address
      user        = "root"
      private_key = file("~/.ssh/id_rsa.pub")
    }
  }
}
