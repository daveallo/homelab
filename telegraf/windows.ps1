Invoke-WebRequest -Uri https://dl.influxdata.com/telegraf/releases/telegraf-$($env:TELEGRAF_VERSION)_windows_amd64.zip `
  -OutFile $env:USERPROFILE\Downloads\telegraf_windows_amd64.zip
Expand-Archive $env:USERPROFILE\Downloads\telegraf_windows_amd64.zip "C:\Program Files\" -Force
Rename-Item "C:\Program Files\telegraf-$env:TELEGRAF_VERSION" Telegraf
New-Item -Path "C:\Program Files\Telegraf\telegraf.d" -ItemType Directory -Force
Invoke-WebRequest -Uri https://raw.githubusercontent.com/daveallo/homelab/refs/heads/main/telegraf/outputs.conf `
  -OutFile "C:\Program Files\Telegraf\telegraf.d\outputs.conf"
Invoke-WebRequest -Uri https://raw.githubusercontent.com/daveallo/homelab/refs/heads/main/telegraf/windows-system.conf `
  -OutFile "C:\Program Files\Telegraf\telegraf.d\windows-system.conf"
( Get-WindowsFeature -Name AD-Domain-Services | Where Installed ) -or ( `
  Invoke-WebRequest -Uri https://raw.githubusercontent.com/daveallo/homelab/refs/heads/main/telegraf/windows-ads.conf `
    -OutFile "C:\Program Files\Telegraf\telegraf.d\windows-ads.conf"
) | Out-Null
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Telegraf" -Force
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Telegraf" `
  -Name Environment `
  -PropertyType MultiString `
  -Value "INFLUX_URL=$env:INFLUX_URL", `
    "INFLUX_TOKEN=$env:INFLUX_TOKEN", `
    "INFLUX_ORG=$env:INFLUX_ORG", `
    "INFLUX_BUCKET=$env:INFLUX_BUCKET" `
  -Force
& "C:\Program Files\Telegraf\telegraf.exe" --config-directory 'C:\Program Files\Telegraf\telegraf.d' service install
Start-Service -Name telegraf
