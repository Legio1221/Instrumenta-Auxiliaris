@{
    # Publish-NugetGithubPackage requirements
    cURL = @{
        Name = "cURL"
        DependencyType = 'Binary'
        Parameters = @{
            "BinaryPath" = "curl" # Change this if curl is not on PATH.
            "InstallInstructions" = "Please use your preferred manner of installing cURL. Official site: https://curl.haxx.se/"
        }
        Version = '7.64.1'
    }
}