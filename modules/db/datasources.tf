# Get list of availability domains

data "oci_identity_availability_domains" "ads" {
  compartment_id = "${var.tenancy_ocid}"
}

# Get DB node list
data "oci_database_db_nodes" "db_nodes1" {
  compartment_id = "${var.compartment_ocid}"
  db_system_id   = "${oci_database_db_system.test_db_system1.id}"
}

# data "oci_database_db_nodes" "db_nodes2" {
#   compartment_id = "${var.compartment_ocid}"
#   db_system_id   = "${oci_database_db_system.test_db_system2.id}"
# }

# Get DB node details
data "oci_database_db_node" "db_node_details1" {
  db_node_id = "${lookup(data.oci_database_db_nodes.db_nodes1.db_nodes[0], "id")}"
}

# data "oci_database_db_node" "db_node_details2" {
#   db_node_id = "${lookup(data.oci_database_db_nodes.db_nodes2.db_nodes[0], "id")}"
# }

# Gets the OCID of the first (default) vNIC
data "oci_core_vnic" "db_node_vnic1" {
   vnic_id = "${data.oci_database_db_node.db_node_details1.vnic_id}"
}

# data "oci_core_vnic" "db_node_vnic2" {
#    vnic_id = "${data.oci_database_db_node.db_node_details2.vnic_id}"
# }

data "oci_database_db_homes" "db_homes1" {
  compartment_id = "${var.compartment_ocid}"
  db_system_id   = "${oci_database_db_system.test_db_system1.id}"
}

# data "oci_database_db_homes" "db_homes2" {
#   compartment_id = "${var.compartment_ocid}"
#   db_system_id   = "${oci_database_db_system.test_db_system2.id}"
# }

data "oci_database_databases" "databases1" {
  compartment_id = "${var.compartment_ocid}"
  db_home_id     = "${data.oci_database_db_homes.db_homes1.db_homes.0.db_home_id}"
}

# data "oci_database_databases" "databases2" {
#   compartment_id = "${var.compartment_ocid}"
#   db_home_id     = "${data.oci_database_db_homes.db_homes2.db_homes.0.db_home_id}"
# }

data "oci_database_db_system_patches" "patches1" {
  db_system_id = "${oci_database_db_system.test_db_system1.id}"
}

# data "oci_database_db_system_patches" "patches2" {
#   db_system_id = "${oci_database_db_system.test_db_system2.id}"
# }

data "oci_database_db_system_patch_history_entries" "patches_history1" {
  db_system_id = "${oci_database_db_system.test_db_system1.id}"
}

# data "oci_database_db_system_patch_history_entries" "patches_history2" {
#   db_system_id = "${oci_database_db_system.test_db_system2.id}"
# }

data "oci_database_db_home_patches" "patches1" {
  db_home_id = "${data.oci_database_db_homes.db_homes1.db_homes.0.db_home_id}"
}

# data "oci_database_db_home_patches" "patches2" {
#   db_home_id = "${data.oci_database_db_homes.db_homes2.db_homes.0.db_home_id}"
# }

data "oci_database_db_home_patch_history_entries" "patches_history1" {
  db_home_id = "${data.oci_database_db_homes.db_homes1.db_homes.0.db_home_id}"
}

# data "oci_database_db_home_patch_history_entries" "patches_history2" {
#   db_home_id = "${data.oci_database_db_homes.db_homes2.db_homes.0.db_home_id}"
# }

data "oci_database_db_versions" "test_db_versions_by_db_system_id1" {
  compartment_id = "${var.compartment_ocid}"
  db_system_id   = "${oci_database_db_system.test_db_system1.id}"
}
# data "oci_database_db_versions" "test_db_versions_by_db_system_id2" {
#   compartment_id = "${var.compartment_ocid}"
#   db_system_id   = "${oci_database_db_system.test_db_system2.id}"
# }

data "oci_database_db_system_shapes" "test_db_system_shapes1" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 2],"name")}"
  compartment_id      = "${var.compartment_ocid}"

  filter {
    name   = "shape"
    values = ["${var.db_system_shape}"]
  }
}

# data "oci_database_db_system_shapes" "test_db_system_shapes2" {
#   availability_domain = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 1],"name")}"
#   compartment_id      = "${var.compartment_ocid}"

#   filter {
#     name   = "shape"
#     values = ["${var.db_system_shape}"]
#   }
# }