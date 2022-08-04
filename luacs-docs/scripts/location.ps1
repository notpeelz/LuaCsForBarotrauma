[System.Collections.ArrayList]$Locations = @()

del -ErrorAction SilentlyContinue alias:cd -Force
function global:cd($path) {
  $loc = Get-Location
  $Locations.Add($loc)
  Set-Location $path
}

function global:Restore-Location {
  $idx = $Locations.Count - 1
  $loc = $Locations[$idx]
  $Locations.RemoveAt($idx)
  Set-Location $loc
}
