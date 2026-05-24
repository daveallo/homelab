Install-ADDSForest `
  -DomainName $env:DOMAIN_NAME `
  -SafeModeAdministratorPassword (ConvertTo-SecureString -String $env:AD_SMA_PASSWORD -AsPlainText -Force) `
  -CreateDnsDelegation:$false `
  -DomainMode "WinThreshold" `
  -DomainNetbiosName $env:DOMAIN_NETBIOS `
  -ForestMode "WinThreshold" `
  -InstallDns:$true `
  -NoRebootOnCompletion:$false `
  -Force:$true
