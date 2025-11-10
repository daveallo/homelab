git clone --depth 1 https://github.com/acmesh-official/acme.sh.git /tmp/acme
cd /tmp/acme && ./acme.sh --install --accountemail $ACME_EMAIL
source $HOME/.bashrc
acme.sh --set-default-ca --server letsencrypt
export CF_Token=$ACME_TOKEN && acme.sh \
  --issue \
  --domain $HOSTNAME.$DOMAIN_NAME \
  --dns dns_cf \
  --dnssleep 30 \
  --keylength 2048 \
  --cert-file '$HOME/.ssl/'$HOSTNAME'.'$DOMAIN_NAME'.crt' \
  --key-file '$HOME/.ssl/'$HOSTNAME'.'$DOMAIN_NAME'.key' \
  --pre-hook 'mkdir -p $HOME/.ssl' \
  --reloadcmd 'openssl pkcs12 \
  -export \
  -out $HOME/.ssl/'$HOSTNAME'.'$DOMAIN_NAME'.pfx \
  -in $HOME/.ssl/'$HOSTNAME'.'$DOMAIN_NAME'.crt \
  -inkey $HOME/.ssl/'$HOSTNAME'.'$DOMAIN_NAME'.key \
  -password pass:'$PFX_PASSWORD' && \
    powershell "Get-ChildItem -Path Cert:\\LocalMachine\\My | Remove-Item" && \
    powershell "Get-WmiObject -Class Win32_TSGeneralSetting -Namespace root\\cimv2\\terminalservices | \`
  Set-WmiInstance -Arguments @{SSLCertificateSHA1Hash=( \`
    Import-PfxCertificate \`
      -Password (ConvertTo-SecureString -String '$PFX_PASSWORD' -AsPlainText -Force) \`
      -CertStoreLocation Cert:\\LocalMachine\\My \`
      -FilePath \$env:HOME\\.ssl\\\'$HOSTNAME'.'$DOMAIN_NAME'.pfx \`
  ).Thumbprint}"'
