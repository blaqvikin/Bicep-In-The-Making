Connect-AzAccount

$AzSubscription = Get-AzSubscription | fl

$Context = Get-AzSubscription -SubscriptionId $AzSubscription.Id | Set-AzContext

$DefaultResourceGroup = Set-AzResourceGroup 'LearnStorage'

New-AzResourceGroupDeployment -Location $ResourceGroup.Location -Force

$Parameters = @{
    Name = "Deployment Name" + (Get-Date).ToString("yyyyMMddHHmmss")
    TemplateFile = /Users/iamroot/Development/Bicep-In-The-Making/Templates/StorageAccounts/deployAzureStorageAccount.bicep
    ResourceGroupName = $ResourceGroup}
New-AzResourceGroupDeployment @Parameters -Verbose
