<#
    .SYNOPSIS
    Tests for the ConvertTo-Nupkg module.
#>
Import-Module "$PSScriptRoot/../source/ConvertTo-Nupkg.psd1"

Describe "ConvertTo-Nupkg Tests" {
    Context "Typical Use Cases" {
        It "Creates nupkg in the output folder and deletes feed directory upon completion" {
            # Arrange
            $projectPath = "$PSScriptRoot/ExampleModule"
            $output = "$PSScriptRoot/output"
            $manifest = "$PSScriptRoot/ExampleModule/ExampleModule.psd1"

            # Act
            ConvertTo-Nupkg -ProjectModulePath $projectPath -Output $output -ManifestFilePath $manifest -DeleteFeed   

            # Assert
            $nupkg = "$PSScriptRoot/output/*.nupkg"
            Test-Path $nupkg | Should -BeTrue
            Test-path "$PSScriptRoot/output/feed" | Should -BeFalse
        }

        It "Creates a nupkg with defaults" {
            # Initial setup
            $priorPath = Get-Location

            # Arrange
            $projectPath = "$PSScriptRoot/ExampleModule"
            Set-Location -Path $projectPath

            # Act
            ConvertTo-Nupkg -ProjectModulePath $projectPath -DeleteFeed

            # Assert
            $feed = "$PSScriptRoot/output/feed"
            Test-Path $feed | Should -BeFalse

            # Clean up
            Set-Location -Path $priorPath
        }

        # Delete the 'output' folders
        Remove-Item -Path "$PSScriptRoot/output" -Recurse
        Remove-Item -Path "$PSScriptRoot/ExampleModule/packages" -Recurse
    }
}