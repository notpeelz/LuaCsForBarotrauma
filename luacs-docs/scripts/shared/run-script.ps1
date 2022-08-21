#!/usr/bin/env pwsh

#requires -Version 7.0
Import-Module $PSScriptRoot/impl/shared/location.psm1

try {
  Update-Location "$PSScriptRoot/.."
  $ScriptName = Split-Path -Path $PSCommandPath -Leaf
  . "$PSScriptRoot/impl/$ScriptName" @args
} finally {
  Restore-Location
}
