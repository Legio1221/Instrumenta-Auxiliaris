<#
    .SYNOPSIS
    Checks silently if requirements are met with PSDepend.
#>
function Test-Requirements
{
    [CmdletBinding(PositionalBinding = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RequirementsFile,

        [Parameter(Mandatory = $false)]
        [switch]$ThrowOnError
    )

    Import-Module "PSDepend"

    if(!(Test-Path -Path $RequirementsFile))
    {
        Write-Debug "The 'Requirements' file was not found!"
        throw [System.ArgumentException]::new("The 'RequirementsFile' supplied path is invalid.", "RequirementsFile")
    }

    $result = Invoke-PSDepend -Path $RequirementsFile -Test -Quiet

    if(!$result -and $ThrowOnError)
    {
        throw [System.Exception]::new("Failed to meet the requirements as per $RequirementsFile!  Use PSDepend for more information.")
    }
    elseif(!$result -and !$ThrowOnError)
    {
        Write-Error "Failed to meet the requirements as per $RequirementsFile! Use PSDepend for more information."
    }

    return $result
}