## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_database_db_system" "test_db_system1" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 2]["name"]
  compartment_id      = var.compartment_ocid
  cpu_core_count      = data.oci_database_db_system_shapes.test_db_system_shapes1.db_system_shapes[0]["minimum_core_count"]
  database_edition    = var.db_edition

  db_home {
    database {
      admin_password = var.db_admin_password
      db_name        = var.db_name
    }
    db_version = var.db_version
  }

  shape                   = var.db_system_shape
  subnet_id               = oci_core_subnet.subnet_3.id
  ssh_public_keys         = [chomp(file(var.ssh_public_key))]
  hostname                = var.hostname
  data_storage_size_in_gb = var.data_storage_size_in_gb
  node_count              = data.oci_database_db_system_shapes.test_db_system_shapes1.db_system_shapes[0]["minimum_node_count"]
}

resource "null_resource" "setup1" {
  depends_on = [oci_database_db_system.test_db_system1]
  provisioner "file" {
    connection {
      host        = data.oci_core_vnic.db_node_vnic1.public_ip_address
      user        = "opc"
      private_key = chomp(file(var.ssh_private_key))
    }
    source      = "scripts/"
    destination = "/tmp/"
  }
}

resource "null_resource" "database-config1" {
  depends_on = [null_resource.setup1]

  provisioner "remote-exec" {
    connection {
      host        = data.oci_core_vnic.db_node_vnic1.public_ip_address
      user        = "opc"
      private_key = chomp(file(var.ssh_private_key))
    }

    inline = [
      "chmod +x /tmp/setup_db1.sh",
      "sudo /tmp/setup_db1.sh > /tmp/d1output1.txt",
    ]
  }
}

