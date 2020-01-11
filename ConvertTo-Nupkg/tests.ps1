Import-Module "$PSScriptRoot/source/ConvertTo-Nupkg.psm1"

Invoke-Pester -Script "$PSScriptRoot/tests/*" -CodeCoverage "$PSScriptRoot/source/ConvertTo-Nupkg.psm1"