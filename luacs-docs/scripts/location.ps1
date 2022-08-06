[System.Collections.ArrayList]$Locations = @()

function Change-Location($path) {
  $loc = Get-Location
  $Locations.Add($loc)
  Set-Location $path
}

function Restore-Location {
  $idx = $Locations.Count - 1
  $loc = $Locations[$idx]
  $Locations.RemoveAt($idx)
  Set-Location $loc
}
