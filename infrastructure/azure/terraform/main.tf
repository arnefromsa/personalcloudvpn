provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=1.36.0"
}

resource "azurerm_resource_group" "openvpn-private" {
  name     = "openvpn-private"
  location = "${var.primary_region}"
}