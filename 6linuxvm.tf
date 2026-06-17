resource "azurerm_linux_virtual_machine" "vm1" {
#vm basic 
  name                = var.vm1_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_virtual_network.vnet.location
  size                = "Standard_DC1ds_v3"
  network_interface_ids = [azurerm_network_interface.nic1.id]
  depends_on = [ azurerm_postgresql_flexible_server.postgres ]

# VM size 
  os_disk {
    name = "myOSdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

# OS 
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

# authentication 
  computer_name  = "studentserver"
  admin_username = var.username
  disable_password_authentication = false 
  admin_password = var.password 

  connection {
      type        = "ssh"
      user        = var.username
      password    = var.password
      host        = self.public_ip_address
    }

  provisioner "remote-exec" {
    inline = [
      "set -e",

      "mkdir -p /home/SaiAzadmin/employee-api/src/main/java/com/example/employeeapi/model",
      "mkdir -p /home/SaiAzadmin/employee-api/src/main/java/com/example/employeeapi/repository",
      "mkdir -p /home/SaiAzadmin/employee-api/src/main/java/com/example/employeeapi/controller",
      "mkdir -p /home/SaiAzadmin/employee-api/src/main/resources/static",
      "mkdir -p /home/SaiAzadmin/employee-api/src/main/resources",

      "sudo chown -R SaiAzadmin:SaiAzadmin /home/SaiAzadmin/employee-api"
    ]
  }

  provisioner "file" {
    content = templatefile("${path.module}/index.html.tpl", {
      vm_ip = azurerm_public_ip.pip1.ip_address
    })

    destination = "/home/SaiAzadmin/employee-api/src/main/resources/static/index.html"
  }

  provisioner "file" {
    source      = "./java/pom.xml"
    destination = "/home/SaiAzadmin/employee-api/pom.xml"
  }

  provisioner "file" {
    source      = "./java/Employee.java"
    destination = "/home/SaiAzadmin/employee-api/src/main/java/com/example/employeeapi/model/Employee.java"
  }

  provisioner "file" {
    source      = "./java/EmployeeRepository.java"
    destination = "/home/SaiAzadmin/employee-api/src/main/java/com/example/employeeapi/repository/EmployeeRepository.java"
  }

  provisioner "file" {
    source      = "./java/EmployeeController.java"
    destination = "/home/SaiAzadmin/employee-api/src/main/java/com/example/employeeapi/controller/EmployeeController.java"
  }

  provisioner "file" {
    source      = "./java/EmployeeApiApplication.java"
    destination = "/home/SaiAzadmin/employee-api/src/main/java/com/example/employeeapi/EmployeeApiApplication.java"
  }

  provisioner "file" {
    source      = "./java/application.properties"
    destination = "/home/SaiAzadmin/employee-api/src/main/resources/application.properties"
  }

  provisioner "file" {
    source      = "./Dockerfile"
    destination = "/home/SaiAzadmin/employee-api/Dockerfile"
  }


  provisioner "remote-exec" {
    inline = [

      "set -e",

      # Install dependencies
      "sudo apt update -y",
      "sudo apt install -y openjdk-17-jdk maven postgresql-client docker.io ",

      "java -version",
      "mvn -version",

      # STEP 4: SET ENV VARIABLES (CORRECT WAY)
      "echo 'DB_HOST=${azurerm_postgresql_flexible_server.postgres.fqdn}' | sudo tee /etc/environment",
      "echo 'DB_PORT=5432' | sudo tee -a /etc/environment",
      "echo 'DB_NAME=${var.db_name}' | sudo tee -a /etc/environment",
      "echo 'DB_USER=${var.postgres-admin-user}' | sudo tee -a /etc/environment",
      "echo 'DB_PASSWORD=${var.postgres-admin-password}' | sudo tee -a /etc/environment",

      # reload environment for current session
      ". /etc/environment",

      "sudo bash -c 'echo export DB_HOST=${azurerm_postgresql_flexible_server.postgres.fqdn} > /etc/profile.d/db.sh'",
      "sudo bash -c 'echo export DB_PORT=5432 >> /etc/profile.d/db.sh'",
      "sudo bash -c 'echo export DB_NAME=${var.db_name} >> /etc/profile.d/db.sh'",
      "sudo bash -c 'echo export DB_USER=${var.postgres-admin-user} >> /etc/profile.d/db.sh'",
      "sudo bash -c 'echo export DB_PASSWORD=${var.postgres-admin-password} >> /etc/profile.d/db.sh'",
      "sudo chmod +x /etc/profile.d/db.sh",

      "sudo bash -c 'echo DB_HOST=${azurerm_postgresql_flexible_server.postgres.fqdn} >> /etc/environment'",
      "sudo bash -c 'echo DB_PORT=5432 >> /etc/environment'",
      "sudo bash -c 'echo DB_NAME=${var.db_name} >> /etc/environment'",
      "sudo bash -c 'echo DB_USER=${var.postgres-admin-user} >> /etc/environment'",
      "sudo bash -c 'echo DB_PASSWORD=${var.postgres-admin-password} >> /etc/environment'",

      "sudo chmod +x /etc/profile.d/db.sh",

      # STEP 5: BUILD PROJECT
      "cd /home/SaiAzadmin/employee-api",
      "mvn clean package -DskipTests",

      # STEP 6: RUN APPLICATION (WITH ENV LOADED)
      "nohup bash -c 'set -a && . /etc/profile.d/db.sh && set +a && java -jar target/*.jar' > app.log 2>&1 &",
      "sleep 10",

      "echo '--- APP LOG ---'",
      "cat app.log || true",

      "ps -ef | grep java | grep -v grep || true",

  # Install Prometheus
"wget https://github.com/prometheus/prometheus/releases/download/v2.53.0/prometheus-2.53.0.linux-amd64.tar.gz",
"tar xvf prometheus-2.53.0.linux-amd64.tar.gz",
"sudo mv prometheus-2.53.0.linux-amd64 /opt/prometheus",

# Create Prometheus config
"printf '%s\n' 'global:' '  scrape_interval: 15s' '' 'scrape_configs:' '  - job_name: \"node\"' '    static_configs:' '      - targets: [\"localhost:9100\"]' | sudo tee /opt/prometheus/prometheus.yml > /dev/null",

# Start Prometheus
"printf '%s\n' '[Unit]' 'Description=Prometheus' 'After=network.target' '' '[Service]' 'ExecStart=/opt/prometheus/prometheus --config.file=/opt/prometheus/prometheus.yml' 'Restart=always' '' '[Install]' 'WantedBy=multi-user.target' | sudo tee /etc/systemd/system/prometheus.service > /dev/null",

"sudo systemctl daemon-reload",
"sudo systemctl enable prometheus",
"sudo systemctl start prometheus",

"wget https://github.com/prometheus/node_exporter/releases/download/v1.8.1/node_exporter-1.8.1.linux-amd64.tar.gz",
"tar xvf node_exporter-1.8.1.linux-amd64.tar.gz",
"sudo mv node_exporter-1.8.1.linux-amd64/node_exporter /usr/local/bin/",
"printf '%s\n' '[Unit]' 'Description=Node Exporter' 'After=network.target' '' '[Service]' 'ExecStart=/usr/local/bin/node_exporter --collector.systemd --collector.processes' 'Restart=always' '' '[Install]' 'WantedBy=multi-user.target' | sudo tee /etc/systemd/system/node_exporter.service > /dev/null",

# Install Node Exporter
"wget https://github.com/prometheus/node_exporter/releases/download/v1.8.1/node_exporter-1.8.1.linux-amd64.tar.gz",
"tar xvf node_exporter-1.8.1.linux-amd64.tar.gz",
"sudo mv node_exporter-1.8.1.linux-amd64/node_exporter /usr/local/bin/",

# Node Exporter Service
"printf '%s\n' '[Unit]' 'Description=Node Exporter' 'After=network.target' '' '[Service]' 'ExecStart=/usr/local/bin/node_exporter' 'Restart=always' '' '[Install]' 'WantedBy=multi-user.target' | sudo tee /etc/systemd/system/node_exporter.service > /dev/null",

"sudo systemctl daemon-reload",
"sudo systemctl enable node_exporter",
"sudo systemctl start node_exporter",

# Install Grafana
"sudo apt-get install -y apt-transport-https software-properties-common wget",
"wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -",
"echo 'deb https://packages.grafana.com/oss/deb stable main' | sudo tee /etc/apt/sources.list.d/grafana.list",
"sudo apt-get update",
"sudo apt-get install -y grafana",

# Start Grafana
"sudo systemctl enable grafana-server",
"sudo systemctl start grafana-server", 

"sleep 60",

"sudo mkdir -p /etc/grafana/provisioning/datasources",
"sudo mkdir -p /etc/grafana/provisioning/dashboards",
"sudo mkdir -p /var/lib/grafana/dashboards",

# Prometheus datasource
"sudo bash -c 'cat > /etc/grafana/provisioning/datasources/prometheus.yml <<EOF\napiVersion: 1\n\ndatasources:\n  - name: Prometheus\n    type: prometheus\n    access: proxy\n    url: http://localhost:9090\n    isDefault: true\nEOF'",

# Dashboard provider
"sudo bash -c 'cat > /etc/grafana/provisioning/dashboards/dashboard.yml <<EOF\napiVersion: 1\n\nproviders:\n  - name: default\n    orgId: 1\n    folder: Infrastructure\n    type: file\n    disableDeletion: false\n    editable: true\n    options:\n      path: /var/lib/grafana/dashboards\nEOF'",

# Download Dashboard 1860
"sudo wget -O /var/lib/grafana/dashboards/1860.json https://grafana.com/api/dashboards/1860/revisions/latest/download",

# Download Dashbaord 405
"sudo wget -O /var/lib/grafana/dashboards/405.json https://grafana.com/api/dashboards/405/revisions/latest/download",

# Download Dashboard 11074
"sudo wget -O /var/lib/grafana/dashboards/11074.json https://grafana.com/api/dashboards/11074/revisions/latest/download",

# Download Dashboard 14513 
"sudo wget -O /var/lib/grafana/dashboards/14513.json https://grafana.com/api/dashboards/14513/revisions/latest/download",

"sudo sed -i 's/$${DS_PROMETHEUS}/Prometheus/g' /var/lib/grafana/dashboards/*.json",
"sudo sed -i 's/DS_PROMETHEUS/Prometheus/g' /var/lib/grafana/dashboards/*.json",
"sudo chown -R grafana:grafana /var/lib/grafana/dashboards",
"sudo chmod -R 755 /var/lib/grafana/dashboards",
"sleep 20",
"sudo systemctl restart grafana-server",

# Restart Grafana
"sudo systemctl restart grafana-server",


    ]
  }
}
