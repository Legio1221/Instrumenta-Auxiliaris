<#
    .SYNOPSIS
        Runs Pester tests with code coverage for Get-Version module.
    .NOTES
        Author - Legio1221
#>
Invoke-Pester "$PSScriptRoot/tests" -CodeCoverage "$PSScriptRoot/source/Get-Version.psm1"