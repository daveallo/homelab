Add-Computer `
  -DomainName $env:DOMAIN_NAME `
  -Credential $(New-Object `
    -TypeName PSCredential `
    -ArgumentList ([pscustomobject]@{
      UserName = $env:AD_USER;
      Password = (ConvertTo-SecureString -String $env:AD_PASSWORD -AsPlainText -Force)[0]})) `
  -OUPath $env:AD_PATH `
  -Restart
