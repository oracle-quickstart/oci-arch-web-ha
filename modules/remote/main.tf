resource "null_resource" "compute-script1" {
  provisioner "file" {
    connection {
      host = "${var.public-ip1}" 
      user = "${var.instance_user}"
      private_key = "${var.ssh_private_key}"
    }
    source      = "scripts/"
    destination = "/tmp/"
  }
}

resource "null_resource" "app-config1" {
  depends_on = ["null_resource.compute-script1"]
  provisioner "remote-exec" {
    connection {
      host = "${var.public-ip1}" 
      user = "${var.instance_user}"
      private_key = "${var.ssh_private_key}"
    }

    inline = [
      "touch /tmp/temp.txt",
      "chmod +x /tmp/my_script1.sh",
      "sudo yes | /tmp/my_script1.sh ${var.db_node_public_ip1} ${var.docker_username} ${var.docker_password} > /tmp/c1output1.txt"
    ]
  }
}

resource "null_resource" "compute-script2" {
  provisioner "file" {
    connection {
      host = "${var.public-ip2}" 
      user = "${var.instance_user}"
      private_key = "${var.ssh_private_key}"
    }
    source      = "scripts/"
    destination = "/tmp/"
  }
}

resource "null_resource" "app-config2" {
  depends_on = ["null_resource.compute-script2"]
    
  provisioner "remote-exec" {

    connection {
      host = "${var.public-ip2}" 
      user = "${var.instance_user}"
      private_key = "${var.ssh_private_key}"
    }

    inline = [
      "chmod +x /tmp/my_script2.sh",
      "sudo yes | /tmp/my_script2.sh ${var.db_node_public_ip1} ${var.docker_username} ${var.docker_password} > /tmp/c2output2.txt"
    ]
  }
}