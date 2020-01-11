<#
    .NOTES
    ======================================================
    Author: Oscar Guillermo Castro Jr.
    Date: October 30th, 2019
    Organization: Jimenez & Associates
    File Name: Build-PSCorePsm1Module.psm1
    Version: 1.0.1
    ======================================================

    .SYNOPSIS
    "Builds" a rudimentary PowerShell Core PSM1 styled project.

    .DESCRIPTION
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

    .PARAMETER SourcePath
    The path to the source, aka project, directory.

    .PARAMETER BuildPath
    Path to the output of the 'build' process. If the directory does not exist, the function will attempt to create it.

    .PARAMETER ModuleManifestPath
    Path to the module manifest file (.psd1).

    If this parameter is not provided, the function uses '$SourcePath/$ModuleName.psd1' for the manifest file.

    .EXAMPLE
    Build-PSCorePsm1Module "SuperCoolModule" # $ModuleName mandatory positional parameter

    Current 'Location' is at 'SuperCoolModule'.

    'SuperCoolModule' Project Directory Structure
    ---------------------------------------------
    |--SuperCoolModule
        |--source
            |-- SuperCoolModule.psd1 (Version 2.1.4)
            |-- SuperCoolModule.psm1


    'Build' Output Structure
    ------------------------
    |--SuperCoolModule
        |--builds
            |--2.1.4
                |-- SuperCoolModule
                    |--SuperCoolModule.psm1
                    |--SuperCoolModule.psd1
        |--source
            |-- SuperCoolModule.psd1 (Version 2.1.4)
            |-- SuperCoolModule.psm1

    
    .EXAMPLE
    Build-PSCorePsm1Module -ModuleName "OceanEyes" -SourcePath "./module" -BuildPath "./dist" -ModuleManifestPath "./module/WeirdManifestFileButOkay.psd1"

    'OceanEyes' Project Directory
    -----------------------------
    |--OceanEyes
        |--module
            |--OceanEyes.psm1 (Version 4.3)
            |--ImportantFolder
                |--ImportantFile.txt
            |--WeirdManifestFileButOkay.psd1
        |--dist
            |--4.2 (An older version)
                |--files
    
    'Build' Output
    --------------
    |--OceanEyes
        |--module
            |--OceanEyes.psm1
            |--ImportantFolder
                |--ImportantFile.txt
            |--OceanEyes.psd1
        |--dist
            |--4.2
                |--files
            |--4.3
                |--OceanEyes
                    |--OceanEyes.psm1
                    |--ImportantFolder
                        |--ImportantFile.txt
                    |--OceanEyes.psd1
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
        [string]$ModuleManifestPath,

        [Parameter(
            Mandatory = $true,
            Position = 0
            )]
        [string]$ModuleName

        # Maybe add a switch for determining if the build output should replace any files in the output folder?
    )

    # Function Variables
    # ======================================================
    [string]$ModuleManifest | Out-Null
    [version]$Version | Out-Null
    [hashtable]$Manifest | Out-Null

    # Function Logic
    # ======================================================
    
    # Test the paths of given variables
    # ------------------------------------------------------
    Write-Verbose "The working directory is: $(Get-Location)"
    if(!$(Test-Path -Path $SourcePath))
    {
        throw [System.ArgumentException]::new('$SourcePath', "Unable to identify the given path for the SourcePath parameter.`nSource Path: $SourcePath")
    }

    if ($PSBoundParameters.ContainsKey('ModuleManifestPath'))
    {
        Write-Verbose '$ModuleManifestPath used!'
        if(!$(Test-Path -Path $ModuleManifestPath))
        {
            throw [System.ArgumentException]::new("$ModuleManifestPath", "Unable to identify the file path for the ModuleManifestPath Parameter")
        }

        $ModuleManifest = $ModuleManifestPath
    }
    else
    {
        Write-Verbose '$ModuleManifestPath not set! Creating a possible location based on default structure.'

        # Need to account for an extra '/' or '\' thrown in there.
        $parent = Split-Path -Path $SourcePath -Parent
        $leaf = Split-Path -Path $SourcePath -Leaf
        $joinedSourcePath = Join-Path -Path $parent -ChildPath $leaf

        $manifestFileName = $ModuleName + ".psd1"
        $ModuleManifest = Join-Path -Path $joinedSourcePath -ChildPath $manifestFileName

        if(!$(Test-Path -Path $ModuleManifest))
        {
            throw [System.ArgumentException]::new("$ModuleManifest", "Unable to find a file according to this function's default definition of a basic PSM1 project.")
        }

        Write-Debug -Message "Manifest path is set to default: $ModuleManifest"
    }

    $Manifest = Import-PowerShellDataFile $ModuleManifest
    $Version = $Manifest.ModuleVersion
    if(!$Version) 
    {
        throw [System.ArgumentNullException]::new('$Manifest.ModuleVersion', "The ModuleVersion node is empty or null!")
    }

    $Destination = Join-Path -Path $BuildPath -ChildPath $Version -AdditionalChildPath $ModuleName

    New-Item -Path $Destination -ItemType "directory" | Out-Null
    Copy-Item -Path "$SourcePath/*" -Destination  $Destination -Recurse | Out-Null

    Write-Information "Copied files from source: $SourcePath to the destination: $Destination"
}