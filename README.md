# Cloud-based VPN for internet access
The idea behind this project is to have a very cheap VPN routing services available for personal use.

The main premise behind this is to be :
- No to low cost
- Have complete control over the infrastructure
- Be secure
- Be reliable

# Infrastructure Architecture
This solution utilises Terraform to build the Azure infrastructure and spins up a N[Netgate pfSense Firewall/VPN/Router image](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/netgate.netgate-pfsense-azure-fw-vpn-router) in an Azure resource group.

## Netgate pfSense Firewall/VPN/Router image
pfSense runs on Ubuntu and very lightweight instance.  The software licensing is FREE to use if you utilise the A0 VM size.  An A0 VM should more than sufficient for personal use, either for home or personal use.

Alternatively, one can download the opensource pfSense ISO, but this could possibly a future feature request. At the moment, as the main requirement for this requirement, is to have a very lightweight and low cost solution, the free option would suffice.

# How to set up the infrastructure

## Windows

### Install Azure CLI
You would first need to install the Azure CLI, which is used to authenticate to your Azure environment.

[Install the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)


### Install Terraform
As the infrastructure is defined in Terraform, you would need to install Terraform.


[Install Terraform](https://www.terraform.io/downloads.html)


### Provisioning the infrastructure
As soon as you have installed the pre-requisites as above, you will need to clone the current repository.

```
git clone https://github.com/arnefromsa/cloudbasedvpnsetup
```

After you have gotten a copy of the repository, move to the /infrastructure/azure/terraform folder
Initialize Terraform
```
terraform init
```

Check the **terraform.tfvars** file, and change the values accordingly.

Log into Azure

```
az login
```

Now run apply to provision into the selected subscription
```
terraform apply
```


