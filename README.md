# Sample-Setup Application Gateway and APIM

This project is based on the [Microsoft APIM Landing Zone Accelerator](https://github.com/Azure/apim-landing-zone-accelerator). 
It represents a sample setup of an Application Gateway deployed in vnet `vnet-apim-gw-test-dev-westeurope-001
` which is peered with vnet `vnet-apim-cs-test-dev-westeurope-001` containing an Azure APIM instance. 
The main goal of this project to gain experience in connecting the Application Gateway with an internally deployed APIM instance and route requests from the internet to the correct endpoints.

## How to deploy

The configuration is intended to be deployed in the ipt Sandbox subscription: https://portal.azure.com/#@iptzug.onmicrosoft.com/resource/subscriptions/da12d467-03ae-4675-aa29-d3b26fdbd2cc/


### Local machine

1. `cd terraform`
2. `terraform init -backend-config=backend.dev.hcl`
3. `terraform apply`

### Azure Devops
Run pipeline https://dev.azure.com/apim-testing/apim-testing/_build?definitionId=6&_a=summary. 
Select the `DEV` environment.  

## How to test
### Developer Portal
The developer portal is exposed at http://ipt-apim.westeurope.cloudapp.azure.com/ (http).

### Gateway
The gateway is exposed at https://ipt-apim.westeurope.cloudapp.azure.com/ (https). 
The conference sample API is exposed by the gateway.
It can be tested with a GET (using curl or postman or similar tools) request to https://ipt-apim.westeurope.cloudapp.azure.com/conference/v2/sessions