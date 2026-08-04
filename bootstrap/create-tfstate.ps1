param (
    [Parameter(Mandatory = $true)]
    [ValidateSet("Dev", "PreProd", "Prod")]
    [string]$Environment
)

$location = "uksouth"

switch ($Environment) {
    "Dev" {
        $resourceGroupName = "s268d01rg-uks-sa-tfstate"
        $storageAccountName = "s268d01stsatfstate"
    }
    "PreProd" {
        $resourceGroupName = "s268t05rg-uks-sa-tfstate"
        $storageAccountName = "s268t05stsatfstate"
    }
    "Prod" {
        $resourceGroupName = "s268p01rg-uks-sa-tfstate"
        $storageAccountName = "s268p01stsatfstate"
    }
}

$subscriptionName = az account show --query name -o tsv
$subscriptionId = az account show --query id -o tsv

Write-Host ""
Write-Host "==================================================="
Write-Host " School Account Terraform Backend Bootstrap"
Write-Host "==================================================="
Write-Host ""
Write-Host "Environment : $Environment"
Write-Host "Subscription : $subscriptionName"
Write-Host "Subscription ID : $subscriptionId"
Write-Host "Resource Group : $resourceGroupName"
Write-Host "Storage Account : $storageAccountName"
Write-Host ""

$confirmation = Read-Host "Continue? (Y/N)"

if ($confirmation.ToUpper() -ne "Y") {
Write-Host "Operation cancelled."
exit
}

Write-Host "Using Azure Subscription:"
az account show --query name -o tsv

Write-Host "`nCreating Resource Group..."
az group create `
    --name $resourceGroupName `
    --location $location

Write-Host "`nCreating Storage Account..."
az storage account create `
    --name $storageAccountName `
    --resource-group $resourceGroupName `
    --location $location `
    --min-tls-version TLS1_2 `
    --sku Standard_LRS `
    --https-only true `
    --allow-blob-public-access false

Write-Host "`nEnabling Blob Versioning..."
az storage account blob-service-properties update `
    --account-name $storageAccountName `
    --resource-group $resourceGroupName `
    --enable-versioning true

Write-Host "`nEnabling Soft Delete for blobs..."
az storage account blob-service-properties update `
    --account-name $storageAccountName `
    --resource-group $resourceGroupName `
    --enable-delete-retention true `
    --delete-retention-days 30

Write-Host "`nEnabling Soft Delete for containers..."
az storage account blob-service-properties update `
    --account-name $storageAccountName `
    --resource-group $resourceGroupName `
    --enable-container-delete-retention true `
    --container-delete-retention-days 30

Write-Host "`nCreating Containers..."

az storage container create `
    --name platform-shared `
    --account-name $storageAccountName `
    --auth-mode login

az storage container create `
    --name platform-ace `
    --account-name $storageAccountName `
    --auth-mode login

az storage container create `
    --name app-state `
    --account-name $storageAccountName `
    --auth-mode login

Write-Host "`nApplying CanNotDelete Lock..."

az lock create `
    --name "TerraformStateProtection" `
    --lock-type CanNotDelete `
    --resource-group $resourceGroupName

Write-Host ""
Write-Host "==================================================="
Write-Host " Terraform backend bootstrap complete"
Write-Host "==================================================="
Write-Host ""
Write-Host "Resource Group : $resourceGroupName"
Write-Host "Storage Account: $storageAccountName"
Write-Host ""