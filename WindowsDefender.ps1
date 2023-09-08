# Check if Windows Defender is enabled
$defenderStatus = Get-MpPreference | Select-Object -ExpandProperty RealTimeProtectionEnabled

# If Windows Defender is not enabled, enable it
if ($defenderStatus -eq $false) {
    Set-MpPreference -RealTimeProtectionEnabled $true
    Start-MpScan -ScanType QuickScan  # Start a quick scan (optional)
    Write-Host "Windows Defender has been enabled."
} else {
    Write-Host "Windows Defender is already enabled."
}


Set-MpPreference -DisableRealtimeMonitoring $false
Set-MpPreference -DisableIOAVProtection $false
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "Real-Time Protection" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableBehaviorMonitoring" -Value 0 -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableOnAccessProtection" -Value 0 -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableScanOnRealtimeEnable" -Value 0 -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 0 -PropertyType DWORD -Force
start-service WinDefend
start-service WdNisSvc

# Enable the Windows Firewall for all profiles
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

# Display the status of the Windows Firewall for all profiles
Get-NetFirewallProfile | Select-Object -Property Name,Enabled
