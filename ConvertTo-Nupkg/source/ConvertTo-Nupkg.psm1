<#
    .NOTES
    ======================================================
    Author: Oscar Guillermo Castro Jr.
    Date: November 21st, 2019
    Organization: Jimenez & Associates
    File Name: ConvertTo-Nupkg.psm1
    Version: 1.0.0
    ======================================================

    .SYNOPSIS
    ======================================================
    Uses Publish-Module to publish a module to a local PS Repository and extract a nupkg.
    ======================================================
#>

<#
    .SYNOPSIS
    Uses Publish-Module to publish a module to a local PS Repository and extract a nupkg.

    If the project's 'PSD1' manifest file is not specified, the function will assume the project's last directory is the project's name and use that to assume a manifest's file path (i.e. path/to/project/CoolProject/CoolProject.psd1).

    .PARAMETER ProjectModulePath
    Path to the directory containing the PSM1-styled module project.
    
    .PARAMETER Output
    Directory where the resulting Nupkg should be sent. 
    
    Defaults to the current location and appends '/packages'.

    .PARAMETER ManifestFilePath
    Path to the Module Manifest file (.PSD1).

    Defaults to the current directory's name and appends '.psd1'. (e.g. /path/to/project => project.psd1)

    .PARAMETER DeleteFeed
    If enabled, the supplied feed for the temporary repository will be deleted.

    .EXAMPLE
    ConvertTo-Nupkg -ProjectModulePath '/path/to/example_project'

    Project Directory Structure
    ---------------------------
    example_project
    |--Packages (Created if needed)
    |--Project.psm1
    |--Project.psd1 (this file is assumed)
    |--(project files and directories)
    
    .EXAMPLE
    ConvertTo-Nupkg -ProjectModulePath '/path/to/ExampleModule' -Output '/path/to/ExampleModule/out' -ManifestFile '/path/to/ExampleModule/manifest/ExampleModule.psd1'
    
    Project Directory Structure
    ---------------------------
    ExampleModule
    |--out (created if needed)
    |--manifest
        |--ExampleModule.psd1
    |--ExampleModule.psm1
    |--(other files)
#>
function ConvertTo-Nupkg
{
    [cmdletbinding(PositionalBinding = $false)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectModulePath,

        [Parameter(Mandatory = $false)]
        [string]$Output = "$(Get-Location)/packages",

        [Parameter(Mandatory = $false)]
        [string]$ManifestFilePath = "$(Get-Location)/$((Get-Location).ToString().Split('/')[-1]).psd1", # Get the name of the project. Based on typical PSM1 project styled directory structure.

        [Parameter(Mandatory = $false)]
        [switch]$DeleteFeed
    )

    # I.) Create output and feed folders if needed.
    # ------------------------------------------------------
    Write-Information 'Creating output and feed folders if needed.'
    $doesOutputExist = Test-Path -Path $Output
    if(!$doesOutputExist)
    {
        Write-Verbose "Creating 'Output' directory."
        New-Item -Path $Output -ItemType Directory | Out-Null
    }

    $nupkgFeed = "$Output/feed"
    $doesFeedExist = Test-Path -Path $nupkgFeed
    if(!$doesFeedExist)
    {
        Write-Verbose "Creating 'Feed' directory"
        New-Item -Path $nupkgFeed -ItemType Directory | Out-Null
    }

    # II.) Create temporary feed.
    # ------------------------------------------------------
    Write-Information "Creating temporary PS Repository."

    $feed = (Resolve-Path -Path "$Output/feed").ToString()
    $tempRepoName = "ConvertTo_NupkgTempRepo"
    $repositoryArguments = @{
        Name = $tempRepoName
        SourceLocation = $feed
        PublishLocation = $feed
        InstallationPolicy = 'Trusted'
    }
    Register-PSRepository @repositoryArguments

    # III.) Publish-Module to temporary repository and copy to output
    # ------------------------------------------------------
    Write-Information "Publishing module to temporary repository."
    Publish-Module -Path $ProjectModulePath -Repository $tempRepoName -NuGetApiKey 'Fake-key-required'

    #$manifest = Import-LocalizedData -FileName $ManifestFilePath
    $nupkg = "$feed/*.nupkg" # There should only be 1 nupkg in this temp feed.
    Copy-Item -Path $nupkg -Destination $Output

    # IV.) Delete temp repo and feed.
    # ------------------------------------------------------
    Write-Information "Deleting temporary repository."
    Unregister-PSRepository -Name $tempRepoName
    
    if($DeleteFeed)
    {
        Write-Verbose "Deleting feed."
        Remove-Item -Path $feed -Recurse
    }
}