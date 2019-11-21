<#
    .NOTES
        Author - Legio1221
    .SYNOPSIS
        Publishes the Get-Version module to the local repository.
#>

Publish-Module -Path "$PSScriptRoot/builds/1.0.0/Get-Version" -Repository "LocalPSRepository" -NuGetApiKey 'Fake-key-needed' -Verbose