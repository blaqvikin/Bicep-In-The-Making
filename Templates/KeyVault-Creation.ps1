$keyVaultName = '<keyVaultName>' # A unique name for the key vault.
$login = '<adminUsername>' # The login that you used in the previous step.
$password = '<Password>'  # The password that you used in the previous step.
$defaultRG = Set-AzDefault -ResourceGroupName <ResourceGroupName>

$vmServerAdministratorLogin = ConvertTo-SecureString $login -AsPlainText -Force
$vmServerAdministratorPassword = ConvertTo-SecureString $password -AsPlainText -Force

New-AzKeyVault -VaultName $keyVaultName -Location southafricanorth -resourceGroupName $defaultRG -EnabledForTemplateDeployment -EnabledForDeployment -EnabledForDiskEncryption -EnablePurgeProtection
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'vmAdministratorLogin' -SecretValue $vmServerAdministratorLogin
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'vmAdministratorPassword' -SecretValue $vmServerAdministratorPassword