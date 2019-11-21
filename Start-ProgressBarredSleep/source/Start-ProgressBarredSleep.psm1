<#
    .NOTES
    ======================================================
    Author: Oscar Guillermo Castro Jr.
    Date: October 30th, 2019
    Organization: Jimenez & Associates
    File Name: Start-ProgressBarredSleep.psm1
    Version: 1.0.0
    Original Source: https://gist.github.com/ctigeek/bd637eeaeeb71c5b17f4
    ======================================================

    .SYNOPSIS
    ======================================================
    Begins a countdown timer progress bar that is measured in seconds.
    ======================================================

    .DESCRIPTION
    ======================================================
    Uses `Start-Sleep -Seconds <SECONDS>` with a progress bar to indicate how much time is left until the 'sleep' is over.
    ======================================================
#>
function Start-ProgressBarredSleep
{
    [cmdletbinding(PositionalBinding = $true)]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [double]$Seconds
    )

    # Function Logic
    # ======================================================
    $completionDateTime = (Get-Date).AddSeconds($Seconds)

    while($completionDateTime -gt (Get-Date))
    {
        $secondsLeft = $completionDateTime.Subtract((Get-Date)).TotalSeconds
        $percent = ( ($Seconds - $secondsLeft) / $Seconds ) * 100
        Write-Progress -Activity "Sleeping" -Status "Sleeping for a while..." -SecondsRemaining $secondsLeft -PercentComplete $percent
        [System.Threading.Thread]::Sleep(100) # Sleep for one-tenth of a second.
    }

    Write-Progress -Activity "Sleeping" -Status "Sleeping for a while..." -SecondsRemaining 0 -Completed
}