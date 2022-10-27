data "template_file" "userdata" {
    template = file("data.tpl")
    vars = {
        dbuser = "${var.mysql_admin_user}",
        dbpassword = "${var.mysql_admin_password}",
        dbname = "${azurerm_mysql_database.wordpress.name}",
        dbadres = "${azurerm_mysql_server.wordpress.fqdn}",
        Filesharename=  "${azurerm_storage_share.vmss.name}",
        Storageaccountkey = "${azurerm_storage_account.vmss.primary_access_key}",
        Storageaccountname = "${azurerm_storage_account.vmss.name}"
    }
}

