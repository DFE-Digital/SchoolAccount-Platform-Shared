# Terraform State Bootstrap
 
## Overview
 
This script provisions the Terraform backend infrastructure for the School Account platform.
 
Terraform state infrastructure is intentionally managed outside of Terraform to avoid circular dependencies and reduce operational risk.
 
The script creates and configures:
 
- Resource Group
- Storage Account
- Terraform state containers
- Blob Versioning
- Blob Soft Delete (30 days)
- Container Soft Delete (30 days)
- HTTPS-only access
- Minimum TLS version 1.2
 
---
 
## Terraform State Architecture
 
A dedicated Terraform State Resource Group and Storage Account are maintained for each environment.
 
### Dev
 
Resource Group
 
```text
s268d01rg-uks-sa-tfstate
```
 
Storage Account
 
```text
s268d01stsatfstate
```
 
### PreProd
 
Resource Group
 
```text
s268t05rg-uks-sa-tfstate
```
 
Storage Account
 
```text
s268t05stsatfstate
```
 
### Prod
 
Resource Group
 
```text
s268p01rg-uks-sa-tfstate
```
 
Storage Account
 
```text
s268p01stsatfstate
```
 
---
 
## Storage Containers
 
The following containers are created within each Storage Account:
 
| Container | Purpose |
|------------|------------|
| platform-shared | SchoolAccount-Platform-Shared Terraform state |
| platform-ace | SchoolAccount-Platform-ACE Terraform state |
| app-state | Application Terraform state |
 
---
 
## Example State Files
 
### platform-shared
 
```text
core-network.tfstate
shared-resources.tfstate
```
 
### platform-ace
 
```text
ace.tfstate
```
 
### app-state
 
```text
alpha.tfstate
manage.tfstate
connect.tfstate
dashboard.tfstate
```
 
---
 
## Security and Protection
 
Each Storage Account is configured with:
 
- HTTPS Only enabled
- Minimum TLS version 1.2
- Public Blob Access disabled
- Blob Versioning enabled
- Blob Soft Delete (30 days)
- Container Soft Delete (30 days)
 

---
 
## Prerequisites
 
Before running the script:
 
1. Open Azure Cloud Shell.
2. Ensure the correct subscription is selected.
3. Upload or clone the script.
 
Verify the current subscription:
 
```powershell
az account show --output table
```
 
---
 
## Usage
 
Run the script for the required environment.
 
### Dev
 
```powershell
./create-tfstate.ps1 -Environment Dev
```
 
### PreProd
 
```powershell
./create-tfstate.ps1 -Environment PreProd
```
 
### Prod
 
```powershell
./create-tfstate.ps1 -Environment Prod
```
 
The script displays the selected Azure subscription, Resource Group and Storage Account before making any changes and requires confirmation before continuing.
 
---
 
## Notes
 
- The script is designed to be run manually from Azure Cloud Shell.
- Terraform backend infrastructure is not managed by Terraform.
- The script uses the currently authenticated Azure context and does not require subscription IDs to be stored in source control.
- The script can be safely re-run if a previous execution fails part-way through.
 
---
 
## Ownership
 
Terraform backend infrastructure supports:
 
- SchoolAccount-Platform-Shared
- SchoolAccount-Platform-ACE
- Future School Account application repositories
 
Any changes to the Terraform backend design should be reviewed by the School Account platform team before implementation.