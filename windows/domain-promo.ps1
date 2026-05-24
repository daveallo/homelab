Install-ADDSDomainController `
  -DomainName $env:DOMAIN_NAME `
  -SafeModeAdministratorPassword (ConvertTo-SecureString -String $env:AD_SMA_PASSWORD -AsPlainText -Force) `
  -Credential (New-Object `
    -TypeName PSCredential `
    -ArgumentList ([pscustomobject]@{
      UserName = $env:DOMAIN_NETBIOS+"\"+$env:AD_USER;
      Password = (ConvertTo-SecureString -String $env:AD_PASSWORD -AsPlainText -Force)[0]})) `
  -InstallDns:$false `
  -Force:$true
