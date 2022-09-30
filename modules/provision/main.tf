# Set up the vlan, dhcp server, nat routing and the vpn on the dhcp_nat device
resource "null_resource" "setup_network_hub" {
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
    source      = "${path.module}/files/tailscale.sh"
    destination = "/root/tailscale.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/vlan.sh",
      "chmod +x /root/dhcp.sh",
      "chmod +x /root/nat.sh",
      "chmod +x /root/tailscale.sh",
      "VLAN_ID=${var.vlan_id} ADDR=2 /root/vlan.sh",
      "VLAN_ID=${var.vlan_id} /root/dhcp.sh",
      "VLAN_ID=${var.vlan_id} /root/nat.sh",
      "AUTH_KEY=${var.ts_auth_key} /root/tailscale.sh",
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

# Set up the vlan and pre-reqs for baremetal hosts
resource "null_resource" "setup_baremetal_hosts" {
  count = var.bare_metal_device_count
  connection {
    type        = "ssh"
    host        = var.baremetal_host_addresses[count.index]
    user        = "root"
    port        = 22
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "${path.module}/files/vlan.sh"
    destination = "/root/vlan.sh"
  }

  provisioner "file" {
    source      = "${path.module}/files/byoh.sh"
    destination = "/root/byoh.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/vlan.sh",
      "chmod +x /root/byoh.sh",
      "VLAN_ID=${var.vlan_id} ADDR=${count.index + 13} /root/vlan.sh",
      "AUTH_KEY=${var.ts_auth_key} /root/byoh.sh",
    ]
  }
}
