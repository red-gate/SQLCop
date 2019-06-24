#Requires -Version 4.0
$ErrorActionPreference = 'Stop'
# Ignoring progress stream is vital to keep the performance
# of Invoke-WebRequest decent in Teamcity
$ProgressPreference = 'SilentlyContinue'

function global:RestoreBuildLevelPackages {
    # Download paket.exe.
    # Use --prefer-nuget to get it from nuget.org first as it is quicker (compressed .nupkg)
    $paketVersion = "" # Set this to the value of a specific version of paket.exe to download if need be.
    & "$PSScriptRoot\..\.paket\paket.bootstrapper.exe" $paketVersion --prefer-nuget

    Push-Location $PsScriptRoot -verbose
    try {
        & "..\.paket\paket.exe" install
        if($LASTEXITCODE -ne 0) {
            throw "paket install exited with code $LASTEXITCODE"
        }
    } finally {
        Pop-Location
    }
}

<#
.SYNOPSIS
Build SQL Cop package.

.DESCRIPTION
This is really a wrapper around build.ps1 (build.ps1 is our actual build script. E.g.(the script that tells you how to build this crazy thing)
2 main steps:
    1 - Restore nuget packages that are needed to get our build engine/tools.
    2 - Execute the build. (Invoke-Build build.ps1)

.EXAMPLE
build -Task Package

.EXAMPLE
build
The simplest example! Just execute the build with default values for the -Task parameter.
#>
function global:Build {
    [CmdletBinding()]
    param(
        # The Tasks to execute. '.' means the default task as defined in build.ps1
        [string[]] $Task = @('.'),
        # The Configuration to build. Either Release or Debug
        [ValidateSet('Release', 'Debug')]
        [string] $Configuration = 'Release',
        # The name of the branch we are building (Set by Teamcity).
        # Will be set by Teamcity. Defaults to 'dev' for local developer builds.
        [string] $BranchName = 'dev',
        # Indicates whether or not BranchName represents the default branch for the source control system currently in use.
        # Will be set by Teamcity. Defaults to $false for local developer builds.
        [bool] $IsDefaultBranch = $false,
        # (Optional) URL to the nuget feed to publish nuget packages to.
        # Will be set by Teamcity.
        [string] $NugetFeedUrl,
        # (Optional) Api Key to the nuget feed to be able to publish nuget packages.
        # Will be set by Teamcity.
        [string] $NugetFeedApiKey,
        # (Optional) A GitHub API Access token used for Pushing and PRs
        [string] $GithubAPIToken
    )

    RestoreBuildLevelPackages

    Push-Location $PsScriptRoot -verbose
    try
    {
      # Import the RedGate.Build module.
      Import-Module '.\packages\RedGate.Build\tools\RedGate.Build.psm1' -Force -DisableNameChecking

      # Call the actual build script
      & '.\packages\Invoke-Build\tools\Invoke-Build.ps1' `
        -File .\build.ps1 `
        -Task $Task `
        -BranchName $BranchName `
        -IsDefaultBranch $IsDefaultBranch `
        -NugetFeedUrl $NugetFeedUrl `
        -NugetFeedApiKey $NugetFeedApiKey `
        -GithubAPIToken $GithubAPIToken
    }
    finally
    {
      Pop-Location
    }
}
Write-Host "This is the SQL Cop repo. And here are the available commands:" -Fore Magenta
Write-Host "`t Build" -Fore Green
Write-Host "For more info, use help <command-name>" -Fore Magenta
