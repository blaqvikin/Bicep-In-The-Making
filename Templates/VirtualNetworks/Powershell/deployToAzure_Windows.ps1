Connect-AzAccount

$AzSubscription = Get-AzSubscription | Out-GridView -OutputMode:Single -Title "Select your Azure Subscription"

$Context = Get-AzSubscription -SubscriptionId $AzSubscription.Id | Set-AzContext

$ResourceGroup = Get-AzResourceGroup | Out-GridView -OutputMode:Single -Title "Select your Resource Group"

New-AzResourceGroupDeployment -Location $ResourceGroup.Location -Force

$Parameters = @{
    Name = "Deployment Name" + (Get-Date).ToString("yyyyMMddHHmmss")
    TemplateFile = 'TemplateFile.bicep'
    ResourceGroupName = 'ResourceGroupToDeployTo'}
New-AzResourceGroupDeployment @Parameters -Verbose