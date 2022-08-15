Import-Module -DisableNameChecking $PSScriptRoot/shared/location.psm1

if ((Get-Command "python3" -ErrorAction SilentlyContinue) -eq $null) {
  echo "python3 not found"
  exit 1
}

python3 $PSScriptRoot/shared/http-server.py ./build `
  --port 8001 `
  --route /:html `
  --route /baro-client:baro-client `
  --route /baro-server:baro-server
