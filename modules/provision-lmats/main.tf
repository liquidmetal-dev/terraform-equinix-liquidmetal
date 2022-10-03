# Set up the vlan, dhcp server, nat routing and various tools required by the
# tests on the management_cluster device
resource "null_resource" "setup_management_cluster" {
  connection {
    type        = "ssh"
    host        = var.network_hub_address
    user        = "root"
    port        = 22
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "${path.module}/files/vlan.sh"
    destination = "/root/vlan.sh"
  }

  provisioner "file" {
    source      = "${path.module}/files/dhcp.sh"
    destination = "/root/dhcp.sh"
  }

  provisioner "file" {
    source      = "${path.module}/files/nat.sh"
    destination = "/root/nat.sh"
  }

  provisioner "file" {
    source      = "${path.module}/files/installables.sh"
    destination = "/root/installables.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/vlan.sh",
      "chmod +x /root/dhcp.sh",
      "chmod +x /root/nat.sh",
      "chmod +x /root/installables.sh",
      "VLAN_ID=${var.vlan_id} ADDR=2 /root/vlan.sh",
      "VLAN_ID=${var.vlan_id} /root/dhcp.sh",
      "VLAN_ID=${var.vlan_id} /root/nat.sh",
      "/root/installables.sh",
    ]
  }
}

# Set up the vlan and configure flintlock on the hosts
resource "null_resource" "setup_microvm_hosts" {
  count = var.microvm_host_device_count
  connection {
    type        = "ssh"
    host        = var.microvm_host_addresses[count.index]
    user        = "root"
    port        = 22
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "${path.module}/files/vlan.sh"
    destination = "/root/vlan.sh"
  }

  provisioner "file" {
    source      = "${path.module}/files/flintlock.sh"
    destination = "/root/flintlock.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/vlan.sh",
      "chmod +x /root/flintlock.sh",
      "VLAN_ID=${var.vlan_id} ADDR=${count.index + 3} /root/vlan.sh",
      "VLAN_ID=${var.vlan_id} FLINTLOCK=${var.flintlock_version} FIRECRACKER=${var.firecracker_version} /root/flintlock.sh",
    ]
  }
}
