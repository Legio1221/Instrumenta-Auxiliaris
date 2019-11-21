# Runs tests for the Module.
Invoke-Pester "$PSScriptRoot/tests" -CodeCoverage "$PSScriptRoot/source/Build-PSCorePsm1Module.psm1" -Verbose