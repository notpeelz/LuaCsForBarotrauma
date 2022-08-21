[System.Collections.ArrayList]$Locations = @()

function Update-Location($path) {
  $loc = Get-Location
  $Locations.Add($loc) > $null
  Set-Location $path > $null
}

function Restore-Location {
  $idx = $Locations.Count - 1
  $loc = $Locations[$idx]
  $Locations.RemoveAt($idx) > $null
  Set-Location $loc > $null
}
