locals {
  common_tags = {
    "ManagedBy"   = "Terraform"
    "Owner"       = "TodoAppTeam"
    "Environment" = "dev"
  }
}

module "rg" {
  source      = "../../module/azurerm_resource_group"
  rg_name     = "rg-dev-todoapp2"
  rg_location = "centralindia"
  tags       = local.common_tags
}

module "acr" {
  depends_on = [module.rg]
  source     = "../../module/azurerm_container_registry"
  acr_name   = "acrdevtodoapp1234"
  rg_name    = "rg-dev-todoapp2"
  location   = "centralindia"
  tags       = local.common_tags
}

module "sql_server" {
  depends_on      = [module.rg]
  source          = "../../module/azurerm_sql_server"
  sql_server_name = "sql-dev-todoapp1235"
  rg_name         = "rg-dev-todoapp2"
  location        = "centralindia"
  admin_username  = "devopsadmin"
  admin_password  = "P@ssw01rd@123"
  tags            = local.common_tags
}

module "sql_db" {
  source       = "../../module/azurerm_sql_database"
  sql_db_name  = "sqldb-dev-todoapp"
  server_id    = module.sql_server.server_id   # 👈 ye sahi hai
  max_size_gb  = "1"
  tags         = local.common_tags
}


module "aks" {
  depends_on = [module.rg]
  source     = "../../module/azurerm_kubernetes_cluster"
  aks_name   = "aks-dev-todoapp13"
  location   = "centralindia"
  rg_name    = "rg-dev-todoapp2"
  dns_prefix = "aks-dev-todoapp"
  tags       = local.common_tags
}
