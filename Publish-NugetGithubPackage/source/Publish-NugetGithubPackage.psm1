<#
    .SYNOPSIS
    Due to the current incompatibility of Github Packages with the *nix / macOS Nuget tool, this function publishes a PowerShell nupkg to Github Packages in lieu of the x-platform.

    .NOTES
    The configuration file is located at $PSScriptRoot/scriptsettings.json
    

    .PARAMETER UpdateConfigFile
    If the switch is provided, the function will update / create a configuration file with the provided credentials at $env:HOME/.config/instrumenta-auxiliaris/publish_nuget-github-packages.json
#>  
function Publish-NugetGithubPackage
{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Nupkg,

        [Parameter(Mandatory = $true)]
        [string]$PackageUrl,

        [Parameter(Mandatory = $false)]
        [string]$GithubUserName,

        [Parameter(Mandatory = $false)]
        [string]$GithubToken,

        [Parameter(Mandatory = $false)]
        [Switch]$UpdateConfigFile
    )

    Invoke-PSDepend -Path "$PSScriptRoot/Requirements.psd1"

    $pathBeforeScript = Get-Location
    $nupkgParent = Split-Path -Path $nupkg -Parent
    $nupkgLeaf = Split-Path -Path $nupkg -Leaf
    $configurationFile = "$PSScriptRoot/scriptsettings.json"

    Set-Location $nupkgParent

    # I.) If left at default, check ~/.config/nuget-github-packages.json for github creds
    if($PSBoundParameters.ContainsKey('GithubUserName') -or $PSBoundParameters.ContainsKey('GithubToken'))
    {
        # Check if the config file is available.
        $isConfig = Test-Path "$env:HOME/.config/nuget-github-packages.json"
        if($isConfig)
        {
            $json = Get-Content -Raw -Path "$env:HOME/.config/nuget-github-packages.json" | ConvertFrom-Json

            if(([string]::IsNullOrWhiteSpace($json.GithubUserName)) -and ($GithubUserName -eq 'default'))
            {
                $GithubUserName = $json.GithubUserName
            }
            else
            {
                throw [System.ArgumentNullException]::new("GithubUserName", "The 'GithubUserName' key-value in the config file is null!")
            }

            if(([string]::IsNullOrWhiteSpace($json.GithubToken)) -and ($GithubToken -eq 'default'))
            {
                $GithubToken = $json.GithubToken
            }
            else
            {
                throw [System.ArgumentNullException]::new("GithubToken", "The 'GithubToken' key-value in the config file is null!")
            }
        }
        else
        {
            throw [System.InvalidOperationException]::new("The `$env:HOME/.config/nuget-github-packages.json file is unavailable. Please supply credentials or update the config file!")
        }
    }

    if($UpdateConfigFile)
    {

    }

    # II.) Attempt package upload
    $githubCredentials = $GithubUserName + ":" + $GithubToken
    $package = "package=@" + $nupkgLeaf

    Write-Information "Attempting to upload package to Github Packages!"
    try
    {
        $curlOutput = curl -vX PUT -u $githubCredentials -F $package $PackageUrl
    }
    catch
    {
        Write-Error "Failed to upload package. Please see cURL output for more information."
    }
    finally
    {
        Set-Location $pathBeforeScript
    }

    Write-Host $curlOutput
}