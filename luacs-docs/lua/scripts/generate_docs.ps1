Import-Module $PSScriptRoot/../../scripts/location.ps1

try {
  cd $PSScriptRoot/LuaDocsGenerator

  if ((Get-Command "dotnet" -ErrorAction SilentlyContinue) -eq $null) {
    echo "dotnet not found"
    exit 1
  }

  dotnet build /p:WarningLevel=0 /p:RunCodeAnalysis=false
  dotnet run --no-build
} finally {
  Restore-Location
}
