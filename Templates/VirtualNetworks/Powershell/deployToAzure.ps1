$AzConnect = Connect-AzAccount

$TargetRG = Get-AzResourceGroup | Select-Object ResourceGroupName, Location | ? ResourceGroupName -EQ 'Learn-Networks'

$Context = Get-AzSubscription -SubscriptionName $AzConnect.SubscriptionName | Set-AzContext

New-AzResourceGroupDeployment -Location $TargetRG.Location -Force

$Parameters = @{
    Name = "Bicep Deployment" + (Get-Date).ToString("yyyyMMddHHmmss")
    TemplateFile = "/home/iamgroot/Development/SandboxDemos/SandboxDemos/Templates/VirtualNetworks/deployvNET.bicep"
    #../VirtualNetworks/deployvNET.bicep
    ResourceGroupName = $TargetRG.ResourceGroupName
}
New-AzResourceGroupDeployment @Parameters -Verbose