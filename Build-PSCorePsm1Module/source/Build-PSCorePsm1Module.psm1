<#
    .NOTES
    ======================================================
    Author: Oscar Guillermo Castro Jr.
    Date: October 30th, 2019
    Organization: Jimenez & Associates
    File Name: Build-PSCorePsm1Module.psm1
    Version: 1.0.0
    ======================================================

    .SYNOPSIS
    ======================================================
    "Builds" a rudimentary PowerShell Core PSM1 styled project.
    ======================================================

    .DESCRIPTION
    ======================================================
    Utilizes a known structure to "build" PS Core PSM1 modules.
    This module creates a build directory based on the module manifest's version.
    The source files are then copied into the new directory with a proper module directory scheme.

    Assumptions for utilizing function's default settings.
    ------------------------------------------------------
    Variable      | Assumptions
    $SourcePath   | Assumes that the working directory contains a folder named 'source'
    $BuildPath    | Assumes that the build output should go into a folder named 'builds' in the working directory. Creates a build folder if missing.
    $ModuleManifestPath | Assumes that the module manifest file is under the assumed 'source' folder (source/$ModuleName.psd1) in the working directory.
    ------------------------------------------------------
    ======================================================
#>
function Build-PSCorePsm1Module
{
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(Mandatory = $false)]
        [string]$SourcePath = "$(Get-Location)/source",

        [Parameter(Mandatory = $false)]
        [string]$BuildPath = "$(Get-Location)/builds",

        [Parameter(Mandatory = $false)]
        [string]$ModuleManifestPath = 'default_path',

        [Parameter(
            Mandatory = $true,
            Position = 0
            )]
        [string]$ModuleName
    )

    # Function Variables
    # ======================================================
    [string]$ModuleManifest | Out-Null
    [version]$Version | Out-Null
    [hashtable]$Manifest | Out-Null

    # Function Logic
    # ======================================================
    if ($ModuleManifestPath -ceq 'default_path')
    {
        $ModuleManifest = "$(Get-Location)/source/$ModuleName.psd1"
        Write-Debug -Message "Manifest path is set to default: `$PSScriptRoot/source/`$ModuleName.psd1"
    }
    else
    {
        $ModuleManifest = $ModuleManifestPath
        Write-Debug -Message "Manifest path is user set: $ModuleManifest"
    }

    if(!$ModuleName)
    {
        throw [System.ArgumentNullException]::new('$ModuleName', "The ModuleName parameter must not be null!")
    }

    # Test the paths of given variables
    # ------------------------------------------------------
    Write-Verbose "The working directory is: $env:PWD"
    if(!$(Test-Path -Path $SourcePath))
    {
        throw [System.ArgumentException]::new('$SourcePath', "Unable to identify the given path for the SourcePath parameter.`nSource Path: $SourcePath")
    }

    <# if(!$(Test-Path -Path $BuildPath))
    {
        New-Item -Path $BuildPath -ItemType 'directory'
    } #>

    if(!$(Test-Path -Path $ModuleManifest))
    {
        throw [System.ArgumentException]::new('$SourcePath', "Unable to identify the file path for the ModuleManifestPath parameter.")
    }

    $Manifest = Import-PowerShellDataFile $ModuleManifest
    $Version = $Manifest.ModuleVersion
    if(!$Version) 
    {
        throw [System.ArgumentNullException]::new('$Manifest.ModuleVersion', "The ModuleVersion node is empty or null!")
    }

    $Destination = "$BuildPath/$Version/$ModuleName"

    New-Item -Path $Destination -ItemType "directory"
    Copy-Item -Path "$SourcePath/*" -Destination  $Destination -Recurse

    Write-Information "Copied files from source: $SourcePath to the destination: $Destination"
}