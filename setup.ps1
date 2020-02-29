$name = "zerodemo"
$rg = "rg" + $name
$location = "koreacentral"
$acr = "acr" + $name
$aks = "aks" + $name
$subscriptionId = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
$kubeVersion = "1.14.8"
$nodeVMSize = "Standard_B2s"

Import-Module -Name Az.Accounts
Write-Output "Provide your credentials to access Azure subscription $subscriptionId" -Verbose
Login-AzAccount -SubscriptionId $subscriptionId
$azureSubscription = Get-AzSubscription -SubscriptionId $subscriptionId
$connectionName = $azureSubscription.Id

Set-AzContext -Subscription $connectionName

# Create one resource group $rg on a specific location $location (for example eastus) which will contain the Azure services we need 
Write-Output "Creating new resource group: $rg" -Verbose
New-AzResourceGroup `
    -Name $rg `
    -Location $location
Write-Output "New resource group: $rg created" -Verbose

Write-Output "deleting service principal file" -Verbose
rm ~/.azure/acsServicePrincipal.json
Write-Output "service principal file deleted" -Verbose

# Write-Output "Creating new storage account" 
# $storageAccount = New-AzStorageAccount `
#     -ResourceGroupName $rg `
#     -Name "$name$(Get-Random)" `
#     -Location $location `
#     -SkuName Standard_LRS `
#     -Kind StorageV2
# $storageAccountName = $storageAccount.StorageAccountName
# Write-Output "New storage account: ($storageAccountName) created" 

# Write-Output "Creating new file share" -Verbose
# $fileShare = New-AzStorageShare `
#     -Name "$name$(Get-Random)" `
#     -Context $storageAccount.Context
# $fileShareName = $fileShare.Name
# Write-Output "New file share: ($fileShareName) created" -Verbose

# Create an ACR registry $acr
Write-Output "Creating new Azure Container registry: $acr" -Verbose
New-AzContainerRegistry -Name $acr -ResourceGroupName $rg -Location $location -Sku Basic
Write-Output "New Azure Container registry: ($acr) created" -Verbose


Write-Output "Generating ssh keys" -Verbose
ssh-keygen -t rsa -b 2048
Write-Output "Ssh keys generated" -Verbose

Write-Output "Creating new Azure Kubernetes Service cluster: $aks" -Verbose
New-AzAks `
    -Name $aks `
    -Location $location `
    -ResourceGroupName $rg `
    -NodeCount 1 `
    -KubernetesVersion $kubeVersion `
    -NodeVmSize $nodeVMSize `
    -Verbose 
Write-Output "New Azure Kubernetes Service cluster: ($aks) created" -Verbose


# Once created (the creation could take ~10 min), get the credentials to interact with your AKS cluster
Write-Output "Getting credentials for Azure Kubernetes Service cluster: $aks" -Verbose
Import-AzAksCredential -ResourceGroupName $rg -Name $aks
Write-Output "Credentials for Azure Kubernetes Service cluster: ($aks) obtained" -Verbose

# Remove-AzResourceGroup -Name $rg

        # $MicroserviceA = false
        # $editedFiles = git diff HEAD HEAD~ --name-only
        #   $editedFiles | ForEach-Object {
        #     Switch -Wildcard ($_ ) {
        #       '**/src/AksCalculator/*' { echo "##vso[task.setvariable variable=MicroserviceA]True" }
        #       '**/azure-pipelines.yml' { echo "##vso[task.setvariable variable=MicroserviceA]True" }
        #     }
        #   }            
        