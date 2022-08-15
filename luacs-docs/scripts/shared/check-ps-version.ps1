if ($PSVersionTable.PSVersion.Major -lt 7) {
  echo "Please run this script with PowerShell 7 (pwsh)"
  [Environment]::Exit(1)
}
