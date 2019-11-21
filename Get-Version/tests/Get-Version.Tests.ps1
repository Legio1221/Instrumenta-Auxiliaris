<#
    .NOTES
        Author - Legio1221
    .SYNOPSiS
        Simple testing for the Get-Version module.
#>

Describe "Get-Version Testing" {
    Import-Module "$PSScriptRoot/../source/Get-Version.psd1"

    Context "csproj format" {
        $csproj = "$PSScriptRoot/sample.csproj"
        $csproj2 = "$PSScriptRoot/sample2.csproj"
        $csproj3 = "$PSScriptRoot/sample3.csproj"

        It "gets the version from a csproj file." {
            [version]$expected = '1.3.4'
            $actual = Get-Version $csproj
            
            $actual.GetType().ToString() | Should -Be "System.Version"
            $actual | Should -Be $expected
        }

        It "uses full syntax to get version from csproj file." {
            [version]$expected = '4.55.3.102'
            $actual = Get-Version -Format csproj -FilePath $csproj2

            $actual | Should -BeExactly $expected
        }

        It "uses partial and positional syntax to get version from csproj file." {
            [version]$expected = '100.2'
            $actual = Get-Version -FilePath $csproj3 # Expects that Format will 'csproj'

            $actual | Should -BeExactly $expected
        }
    }
}