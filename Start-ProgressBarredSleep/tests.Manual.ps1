<#
    .NOTES
        Author: Legio1221
    .SYNOPSIS
        This tests runs the Start-ProgressBarredSleep function but depends on the user to verify that it does in fact work.
#>

Import-Module "$PSScriptRoot/source/Start-ProgressBarredSleep.psm1"

Start-ProgressBarredSleep -Seconds 10