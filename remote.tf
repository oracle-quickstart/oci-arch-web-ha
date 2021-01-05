## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "null_resource" "compute-script1" {
  depends_on = [oci_core_instance.compute_instance1, oci_database_autonomous_database.ATPdatabase, oci_core_network_security_group_security_rule.ATPSecurityEgressGroupRule, oci_core_network_security_group_security_rule.ATPSecurityIngressGroupRules]
  
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.compute_instance1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    inline = [
      "echo '== [compute_instance1] 1. Install Oracle instant client'",
      "sudo -u root yum -y install oracle-release-el7",
      "sudo -u root yum-config-manager --enable ol7_oracle_instantclient",
      "sudo -u root yum -y install oracle-instantclient18.3-basic",
      "sudo -u root yum -y install oracle-instantclient18.3-sqlplus",

      "echo '== [compute_instance1] 2. Install Python3, and then with pip3 cx_Oracle and flask'",
      "sudo -u root yum install -y python36",
      "sudo -u root pip3 install cx_Oracle",
      "sudo -u root pip3 install flask",

      "echo '== [compute_instance1] 3. Disabling firewall and starting HTTPD service'",
      "sudo -u root service firewalld stop",
      
      "echo '== [compute_instance1] 4. Prepare Flask directory structure'",
      "sudo -u root mkdir /home/opc/templates",
      "sudo -u root chown opc /home/opc/templates/",
      "sudo -u root mkdir /home/opc/static/",
      "sudo -u root chown opc /home/opc/static",
      "sudo -u root mkdir /home/opc/static/css/",
      "sudo -u root chown opc /home/opc/static/css/",
      "sudo -u root mkdir /home/opc/static/img",
      "sudo -u root chown opc /home/opc/static/img/"
      ]
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.compute_instance1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "flask_dir/static/css/"
    destination = "/home/opc/static/css"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.compute_instance1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "flask_dir/static/img/"
    destination = "/home/opc/static/img"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.compute_instance1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "flask_dir/templates/"
    destination = "/home/opc/templates"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.compute_instance1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "flask_dir/"
    destination = "/home/opc/"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.compute_instance1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "db_scripts/"
    destination = "/home/opc/"
  }

  provisioner "local-exec" {
    command = "echo '${oci_database_autonomous_database_wallet.ATP_database_wallet.content}' >> ${var.ATP_tde_wallet_zip_file}_encoded"
  }

  provisioner "local-exec" {
    command = "base64 --decode ${var.ATP_tde_wallet_zip_file}_encoded > ${var.ATP_tde_wallet_zip_file}"
  }

  provisioner "local-exec" {
    command = "rm -rf ${var.ATP_tde_wallet_zip_file}_encoded"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.compute_instance1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = var.ATP_tde_wallet_zip_file
    destination = "/home/opc/${var.ATP_tde_wallet_zip_file}"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.compute_instance1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    inline = [
      "echo '== [compute_instance1] 4. Unzip TDE wallet zip file'",
      "sudo -u root unzip -o /home/opc/${var.ATP_tde_wallet_zip_file} -d /usr/lib/oracle/18.3/client64/lib/network/admin/",
      
      "echo '== [compute_instance1] 5. Move sqlnet.ora to /usr/lib/oracle/18.3/client64/lib/network/admin/'",
      "sudo -u root cp /home/opc/sqlnet.ora /usr/lib/oracle/18.3/client64/lib/network/admin/"]
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.compute_instance1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    inline = [
      "echo '== [compute_instance1] 6. Create DEPT table in ATP'",
      "sudo -u root sed -i 's/ATP_password/${var.ATP_password}/g' /home/opc/db1.sql",
      "sudo -u root sed -i 's/ATP_password/${var.ATP_password}/g' /home/opc/db1.sh",
      "sudo -u root sed -i 's/ATP_database_db_name/${var.ATP_database_db_name}/g' /home/opc/db1.sh",
      "sudo -u root chmod +x /home/opc/db1.sh",
      "sudo -u root /home/opc/db1.sh"
    ]
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.compute_instance1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    inline = [
      "echo '== [compute_instance1] 7. Run Flask with ATP access'",
      "sudo -u root python3 --version",
      "sudo -u root chmod +x /home/opc/app.sh",
      "sudo -u root sed -i 's/ATP_password/${var.ATP_password}/g' /home/opc/app.py",
      "sudo -u root sed -i 's/ATP_alias/${var.ATP_database_db_name}_medium/g' /home/opc/app.py",
      "sudo -u root nohup /home/opc/app.sh > /home/opc/app.log &",
      "echo 'nohup /home/opc/app.sh > /home/opc/app.log &' | sudo tee -a  /etc/rc.d/rc.local",
      "sudo -u root chmod +x /etc/rc.d/rc.local",
      "sudo -u root systemctl enable rc-local",
      "sudo -u root systemctl status rc-local.service",
      "sudo -u root systemctl start rc-local",
      "sudo -u root systemctl stop firewalld",
      "sudo -u root systemctl disable firewalld",
      "sleep 5",
      "sudo -u root ps -ef | grep app"]
  }
}

resource "null_resource" "compute-script2" {
  depends_on = [oci_core_instance.compute_instance1, oci_database_autonomous_database.ATPdatabase, null_resource.compute-script1]
  
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.compute_instance2.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    inline = [
      "echo '== [compute_instance2] 1. Install Oracle instant client'",
      "sudo -u root yum -y install oracle-release-el7",
      "sudo -u root yum-config-manager --enable ol7_oracle_instantclient",
      "sudo -u root yum -y install oracle-instantclient18.3-basic",

      "echo '== [compute_instance2] 2. Install Python3, and then with pip3 cx_Oracle and flask'",
      "sudo -u root yum install -y python36",
      "sudo -u root pip3 install cx_Oracle",
      "sudo -u root pip3 install flask",

      "echo '== [compute_instance2] 3. Disabling firewall and starting HTTPD service'",
      "sudo -u root service firewalld stop",
      
      "echo '== [compute_instance2] 4. Prepare Flask directory structure'",
      "sudo -u root mkdir /home/opc/templates", 
      "sudo -u root chown opc /home/opc/templates/",
      "sudo -u root mkdir /home/opc/static/",
      "sudo -u root chown opc /home/opc/static",
      "sudo -u root mkdir /home/opc/static/css/",
      "sudo -u root chown opc /home/opc/static/css/",
      "sudo -u root mkdir /home/opc/static/img",
      "sudo -u root chown opc /home/opc/static/img/"
      ]
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.compute_instance2.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "flask_dir/static/css/"
    destination = "/home/opc/static/css"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.compute_instance2.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "flask_dir/static/img/"
    destination = "/home/opc/static/img"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.compute_instance2.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "flask_dir/templates/"
    destination = "/home/opc/templates"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.compute_instance2.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "flask_dir/"
    destination = "/home/opc/"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.compute_instance2.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "db_scripts/"
    destination = "/home/opc/"
  }

  provisioner "local-exec" {
    command = "echo '${oci_database_autonomous_database_wallet.ATP_database_wallet.content}' >> ${var.ATP_tde_wallet_zip_file}_encoded"
  }

  provisioner "local-exec" {
    command = "base64 --decode ${var.ATP_tde_wallet_zip_file}_encoded > ${var.ATP_tde_wallet_zip_file}"
  }

  provisioner "local-exec" {
    command = "rm -rf ${var.ATP_tde_wallet_zip_file}_encoded"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.compute_instance2.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = var.ATP_tde_wallet_zip_file
    destination = "/home/opc/${var.ATP_tde_wallet_zip_file}"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.compute_instance2.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    inline = [
      "echo '== [compute_instance2] 4. Unzip TDE wallet zip file'",
      "sudo -u root unzip -o /home/opc/${var.ATP_tde_wallet_zip_file} -d /usr/lib/oracle/18.3/client64/lib/network/admin/",
      
      "echo '== [compute_instance2] 5. Move sqlnet.ora to /usr/lib/oracle/18.3/client64/lib/network/admin/'",
      "sudo -u root cp /home/opc/sqlnet.ora /usr/lib/oracle/18.3/client64/lib/network/admin/"]
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.compute_instance2.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    inline = [
      "echo '== [compute_instance2] 6. Run Flask with ATP access'",
      "sudo -u root python3 --version",
      "sudo -u root chmod +x /home/opc/app.sh",
      "sudo -u root sed -i 's/ATP_password/${var.ATP_password}/g' /home/opc/app.py",
      "sudo -u root sed -i 's/ATP_alias/${var.ATP_database_db_name}_medium/g' /home/opc/app.py",
      "sudo -u root nohup /home/opc/app.sh > /home/opc/app.log &",
      "echo 'nohup /home/opc/app.sh > /home/opc/app.log &' | sudo tee -a  /etc/rc.d/rc.local",
      "sudo -u root chmod +x /etc/rc.d/rc.local",
      "sudo -u root systemctl enable rc-local",
      "sudo -u root systemctl status rc-local.service",
      "sudo -u root systemctl start rc-local",
      "sudo -u root systemctl stop firewalld",
      "sudo -u root systemctl disable firewalld",
      "sleep 5",
      "sudo -u root ps -ef | grep app"]
  }
}

     

