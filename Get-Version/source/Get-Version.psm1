<#
    .NOTES
    ======================================================
    Author: Oscar Guillermo Castro Jr.
    Date: October 25th, 2019
    Organization: Jimenez & Associates
    File Name: Get-Version.psm1
    Version: 1.0.0
    ======================================================

    .SYNOPSIS
    ======================================================
    Retrieves a `System.Version` object (semantic versioning) from a given format.
    Currently only suppports .CSPROJ files from a SDK-styled project!
    ======================================================
#>

# ======================================================
#                    Public Functions
# ======================================================
function Get-Version
{
    [cmdletbinding(PositionalBinding = $false)]
    [OutputType([version])]
    param(
        [Parameter(Mandatory = $false)]
        [string]$Format = "csproj",

        [Parameter(
            Mandatory = $true,
            Position = 0
            )]
        [string]$FilePath
    )

    # Function Logic
    # ======================================================
    Process
    {
        [version]$version | Out-Null # Need Out-Null as PowerShell will return uncaptured statements (This line'll spit out some sort of empty value resulting in an array instead of a [version] object).

        switch($Format)
        {
            "csproj" {
                [version]$version = Get-CsprojVersion -FilePath $FilePath
                Write-Debug $version.GetType()
            }
        }

        return $version
    }
}

# ======================================================
#                   Private functions
# ======================================================

<#
    .SYNOPSIS
        Retrieves from the CS Project's <Version> node.
        Assumes a .NET Core SDK styled project.
#>
function Get-CsprojVersion
{
    param(
        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )

    [XML]$csproj = Get-Content $FilePath
    [version]$version = $csproj.Project.PropertyGroup.Version

    return $version
}