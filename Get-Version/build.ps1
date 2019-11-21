<#
    .SYNOPSIS
        Builds the solutions sends output to the version appropriate folder under the 'builds' directory.
    .NOTES
        Author - Oscar Guillermo Castro Jr.
#>

$source = "$PSScriptRoot/source"
$module = "Get-Version"

$manifest = Import-PowerShellDataFile "$source/$module.psd1"
$version = $manifest.ModuleVersion

$builds = "$PSScriptRoot/builds/$version/$module"

New-Item -Path $builds -ItemType "directory"
Copy-Item -Path "$source/*" -Destination $builds -Recurse -Verbose