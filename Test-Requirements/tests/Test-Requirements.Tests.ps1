<#
    .SYNOPSIS
    Unit and Integration tests for Test-Requirements
#>
Describe "Test-Requirement unit and integration testing" {
    Import-Module "$PSScriptRoot/../source/Test-Requirements.psd1"

    Context "Unit testing" {

        $requirementFileDirectory = "$PSScriptRoot/RequirementFiles"
        It "Checks requirements and passes!" {
            Test-Requirements -RequirementsFile "$requirementFileDirectory/FakeProject.Requirements.psd1" | Should -BeTrue
        }

        It "Fails and does not throw." {
            Test-Requirements -RequirementsFile "$requirementFileDirectory/Fails.Requirements.psd1" -ErrorAction SilentlyContinue | Should -BeFalse
        }

        It "Fails and throws." {
            { Test-Requirements -RequirementsFile "$requirementFileDirectory/Fails.Requirements.psd1" -ThrowOnError } | Should -Throw
        }

        It "does not find a requirements file and throws." {
            { Test-Requirements -RequirementsFile "$PSScriptRoot/FakeNews/FakeMedia" } | Should -Throw
        }
    }
}