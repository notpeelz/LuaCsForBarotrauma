try {
  cd $PSScriptRoot/..

  if ((Get-Command "python3" -ErrorAction SilentlyContinue) -eq $null) {
    echo "python3 not found"
    exit 1
  }

  python3 -m http.server -d html
} finally {
  popd
}
