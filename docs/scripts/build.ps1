try {
  cd $PSScriptRoot/..

  Remove-Item -Force -Recurse ./html | Out-Null
  New-Item -ItemType Directory ./html | Out-Null
  Copy-Item -Path ./css/. -Destination ./html -Recurse -Force | Out-Null
  Copy-Item -Path ./js/. -Destination ./html -Recurse -Force | Out-Null

  if ((Get-Command "lua_modules/bin/ldoc" -ErrorAction SilentlyContinue) -eq $null) {
    echo "ldoc not found; please run docs/scripts/install.ps1"
    exit 1
  }

  lua_modules/bin/ldoc .
} finally {
  popd
}
