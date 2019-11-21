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
    Performs unit tests assuring that the Build-PSCorePsm1Module module works as intended.
    ======================================================
#>

Describe "Build-PSCorePsm1Module Behaviour Tests" {
    Import-Module "$PSScriptRoot/../source/Build-PSCorePsm1Module.psm1"

    Context "Build with defaults" {

        # Save the working directory as the default route requires using the working directory.
        $workingDirectory = $env:PWD
        Set-Location -Path "$PSScriptRoot/Example-Module/"

        It "builds a powershell module with a default structure." {
            
            Write-Debug "Should be this path: $PSScriptRoot"
            Write-Debug "The path for behaviour tests is: $(Get-Location)"

            Build-PSCorePsm1Module -ModuleName "Invoke-DoNothing" -Verbose # Let the defaults go!
            
            Import-Module "$PSScriptRoot/Example-Module/builds/0.0.1/Invoke-DoNothing/Invoke-DoNothing.psd1"
            $moduleName = $(Get-Module "Invoke-DoNothing").Name

            $moduleName | Should -BeExactly 'Invoke-DoNothing'
        } -Debug

        It "builds a PSM1 module with specified files and directories." {
            Set-Location "$PSScriptRoot"

            Build-PSCorePsm1Module -ModuleName "Invoke-DoNothingAsWell" -SourcePath "$PSScriptRoot/Example-Module/source" -BuildPath "$PSScriptRoot/Example-Module/custom_builds" -ModuleManifestPath "$PSScriptRoot/Example-Module/source/Invoke-DoNothing.psd1"
            
            Import-Module "$PSScriptRoot/Example-Module/custom_builds/0.0.1/Invoke-DoNothingAsWell/Invoke-DoNothingAsWell.psd1"
            $moduleName = $(Get-Module "Invoke-DoNothingAsWell").Name

            $moduleName | Should -BeExactly "Invoke-DoNothingAsWell"

        }

        Set-Location -Path $workingDirectory
    }
}