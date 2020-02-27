resource "null_resource" "compute-script1" {
  depends_on = [oci_database_db_system.test_db_system1]
  provisioner "file" {
    connection {
      host        = oci_core_instance.compute_instance1.public_ip
      user        = "opc"
      private_key = chomp(file(var.ssh_private_key))
    }
    source      = "scripts/"
    destination = "/tmp/"
  }
}

resource "null_resource" "app-config1" {
  depends_on = [null_resource.compute-script1]
  provisioner "remote-exec" {
    connection {
      host        = oci_core_instance.compute_instance1.public_ip
      user        = "opc"
      private_key = chomp(file(var.ssh_private_key))
    }

    inline = [
      "chmod +x /tmp/script1.sh",
      "sudo yes | /tmp/script1.sh ${data.oci_core_vnic.db_node_vnic1.public_ip_address} ${var.docker_username} ${var.docker_password} > /tmp/output1.txt",
    ]
  }
}

resource "null_resource" "compute-script2" {
  depends_on = [oci_database_db_system.test_db_system1]
  provisioner "file" {
    connection {
      host        = oci_core_instance.compute_instance2.public_ip
      user        = "opc"
      private_key = chomp(file(var.ssh_private_key))
    }
    source      = "scripts/"
    destination = "/tmp/"
  }
}

resource "null_resource" "app-config2" {
  depends_on = [null_resource.compute-script2]

  provisioner "remote-exec" {
    connection {
      host        = oci_core_instance.compute_instance2.public_ip
      user        = "opc"
      private_key = chomp(file(var.ssh_private_key))
    }

    inline = [
      "chmod +x /tmp/script2.sh",
      "sudo yes | /tmp/script2.sh ${data.oci_core_vnic.db_node_vnic1.public_ip_address} ${var.docker_username} ${var.docker_password} > /tmp/output2.txt",
    ]
  }
}

