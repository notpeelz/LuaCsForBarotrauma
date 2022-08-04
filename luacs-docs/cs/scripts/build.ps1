Import-Module $PSScriptRoot/../../scripts/location.ps1

try {
  cd $PSScriptRoot/..

  if ((Get-Command "doxgen" -ErrorAction SilentlyContinue) -eq $null) {
    echo "doxygen not found"
    exit 1
  }

  Remove-Item -Force -Recurse ./build | Out-Null
  New-Item -ItemType Directory ./build | Out-Null
  New-Item -ItemType Directory ./build/baro-server | Out-Null
  New-Item -ItemType Directory ./build/baro-client | Out-Null

  echo "Building server docs"
  try {
    cd ./baro-server
    doxygen ./Doxyfile
  } finally {
    Restore-Location
  }

  echo "Building client docs"
  try {
    cd ./baro-client
    doxygen ./Doxyfile
  } finally {
    Restore-Location
  }

  echo "Building shared docs"
  doxygen ./Doxyfile
} finally {
  Restore-Location
}
