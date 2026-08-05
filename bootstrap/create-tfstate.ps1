param (
    [Parameter(Mandatory = $true)]
    [ValidateSet("Dev", "PreProd", "Prod")]
    [string]$Environment
)

$location = "uksouth"

switch ($Environment) {
    "Dev" {
        $resourceGroupName = "s268d01rg-uks-sa-tfstate"
        $storageAccountName = "s268d01sttfstate"
        $environmentTag = "Dev"
    }
    "PreProd" {
        $resourceGroupName = "s268t05rg-uks-sa-tfstate"
        $storageAccountName = "s268t05sttfstate"
        $environmentTag = "PreProd"
    }
    "Prod" {
        $resourceGroupName = "s268p01rg-uks-sa-tfstate"
        $storageAccountName = "s268p01sttfstate"
        $environmentTag = "Prod"
    }
}

$subscriptionName = az account show --query name -o tsv
$subscriptionId = az account show --query id -o tsv

Write-Host ""
Write-Host "==================================================="
Write-Host " School Account Terraform Backend Bootstrap"
Write-Host "==================================================="
Write-Host ""
Write-Host "Environment : $environmentTag"
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
    --location $location `
    --tags `
        Environment=$environmentTag `
        "Parent Business=Funding and Allocations" `
        "Portfolio=Education and Skills Funding Agency" `
        "Product=School Account" `
        "Service=Funding and Allocations" `
        "Service Line=Funding" `
        "Service Offering=School Account"

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

Write-Host ""
Write-Host "==================================================="
Write-Host " Terraform backend bootstrap complete"
Write-Host "==================================================="
Write-Host ""
Write-Host "Resource Group : $resourceGroupName"
Write-Host "Storage Account: $storageAccountName"
Write-Host ""