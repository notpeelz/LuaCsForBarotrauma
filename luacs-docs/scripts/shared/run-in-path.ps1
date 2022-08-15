param(
  [parameter(position=0)]$Path,
  [parameter(position=1, ValueFromRemainingArguments=$true)]$Command
)

. $PSScriptRoot/check-ps-version.ps1

Import-Module -DisableNameChecking $PSScriptRoot/location.psm1

try {
  Change-Location "$Path"
  $Args = $Command | Select-Object -Skip 1
  . $Command[0] @Args
} finally {
  Restore-Location
}
