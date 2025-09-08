resource "azurerm_managed_identity" "example" {
  name                = "example-identity"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}