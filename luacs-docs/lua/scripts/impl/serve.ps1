if ((Get-Command "python3" -ErrorAction SilentlyContinue) -eq $null) {
  echo "python3 not found"
  exit 1
}

python3 $PSScriptRoot/shared/http_server.py ./build --port 8000
