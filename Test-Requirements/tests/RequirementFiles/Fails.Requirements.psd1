@{
    # Faked requirements for testing purposes.
    whois = @{
        "Name" = "whois CLI Tool"
        "DependencyType" = "Binary"
        "Parameters" = @{
            "BinaryPath" = "whois_but_does_not_exist"
            "InstallInstructions" = "Please see online documentation of 'whois'"
            "ImportInstructions" = "Import not available for 'whois'"
        }
        "Version" = '0.0.1'
    }
}