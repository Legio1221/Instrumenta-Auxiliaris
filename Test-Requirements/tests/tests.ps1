<#
    .SYNOPSIS
    Runs pester tests.
#>
Invoke-Pester "$PSScriptRoot" -CodeCoverage "$PSScriptRoot/../source/Test-Requirements.psm1"