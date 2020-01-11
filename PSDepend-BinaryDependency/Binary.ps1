<#
    .SYNOPSIS
        A binary CLI dependency (e.g. curl)
    .DESCRIPTION
        Binary dependencies for PSDepend. Identifying whether a binary exists and what version that binary may be is difficult without serious man-hours investment.
        This dependency for PSDepend simple attempts to find whether a binary exists with 'Get-Command' and a supplied path.

        If a binary is located on PATH, simply pass the binary executable's name to 'BinaryPath' parameter. Otherwise supply an absolute path to the executable as a parameter.

    .PARAMETER Dependency
        Dependency to process
    
    .PARAMETER PSDependAction
        Test, Install, or Import the dependency.  Defaults to Test.

        Test: Return true or false on whether the dependency is in place
        Install: Writes instructions on how to install the binary dependency.
        Import: Writes instructions on how to import the binary if available.
    
    .PARAMETER BinaryPath
        Path to binary executable (meant for CLI binaries. e.g. curl)
        If a binary is on PATH, simple pass that executable's name (e.g. whereis). Otherwise pass an absolute path to the executable (e.g. /path/to/executable/whereis).
#>
[cmdletbinding()]
param(
    [PSTypeName('PSDepend.Dependency')]
    [psobject[]]$Dependency,

    [ValidateSet('Test', 'Install', 'Import')]
    [string[]]$PSDependAction = @('Test'),

    [string]$BinaryPath,

    [string]$InstallInstructions,

    [string]$ImportInstructions
)

$Output = [PSCustomObject]@{
    DependencyName = $Dependency.DependencyName
    Status = "Invoking $PSDependAction action"
    BoundParameters = $PSBoundParameters.Keys
    Message = ""
}

if( $PSDependAction -contains 'Test')
{
    try {
        $previousErrorActionPreference = $ErrorActionPreference
        $ErrorActionPreference = 'Stop'

        Get-Command -Name $BinaryPath | Out-Null

        $Output.Message = "Found a binary located at $BinaryPath"
        Write-Information $Output
        return $true
    }
    catch {
        $Output.Message = "Unable to find the binary located at $BinaryPath"
        Write-Information $Output
        return $false
    }
    finally {
        $ErrorActionPreference = $previousErrorActionPreference
    }
}

if( $PSDependAction -contains 'Install')
{
    if(![string]::IsNullOrWhiteSpace($InstallInstructions))
    {
        Write-Host $InstallInstructions
    }
    else
    {
        Write-Host "Install instructions were not provided."
    }

    $Output.Message = "See host for further install instructions on the binary dependency."
    Write-Verbose $Output
}

if( $PSDependAction -contains 'Import')
{
    if(![string]::IsNullOrWhiteSpace($ImportInstructions))
    {
        Write-Host $ImportInstructions
    }
    else
    {
        Write-Host "Import instructions were not provided."
    }

    $Output.Message = "See host for further import instructions on the binary dependency."
    Write-Verbose $Output
}