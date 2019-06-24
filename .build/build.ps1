[CmdletBinding()]
param(
    [string] $Configuration = 'Release',
    [string] $BranchName = 'dev',
    [bool] $IsDefaultBranch = $false,
    [string] $NugetFeedUrl,
    [string] $NugetFeedApiKey,
    [string] $GithubAPIToken
)

$RootDir = "$PsScriptRoot\.." | Resolve-Path
$NugetPackageOutputDir = "$RootDir\nugetpackages"
$NugetExe = "$PSScriptRoot\packages\Nuget.CommandLine\tools\Nuget.exe" | Resolve-Path
$Repo = "SQLCop"

task CreateFolders {
    New-Item $NugetPackageOutputDir -ItemType Directory -Force | Out-Null
}

# Synopsis: Retrieve three part version information and release notes from $RootDir\RELEASENOTES.md
# $script:Version = Major.Minor.Build.$VersionSuffix (for installer.tasks)
# $script:ReleaseNotes = read from RELEASENOTES.md
function GenerateVersionInformationFromReleaseNotesMd([int] $VersionSuffix) {
    $ReleaseNotesPath = "$RootDir\RELEASENOTES.md" | Resolve-Path
    $Notes = Read-ReleaseNotes -ReleaseNotesPath $ReleaseNotesPath -ThreePartVersion
    $script:Version = [System.Version] "$($Notes.Version).$VersionSuffix"
    $script:ReleaseNotes = [string] $Notes.Content

    TeamCity-PublishArtifact "$ReleaseNotesPath"
}

# Ensures the following are set
# $script:Version
# $script:ReleaseNotes
task GenerateVersionInformation {
    "Retrieving version information"

    # For dev builds, version suffix is always 0
    $versionSuffix = 0
    if($env:BUILD_NUMBER) {
        $versionSuffix = $env:BUILD_NUMBER
    }

    GenerateVersionInformationFromReleaseNotesMd($versionSuffix)

    TeamCity-SetBuildNumber $script:Version

    "Version = $script:Version"
    "ReleaseNotes = $script:ReleaseNotes"
    
    $script:NugetPackageVersion = New-NugetPackageVersion -Version $script:Version -BranchName $BranchName -IsDefaultBranch $IsDefaultBranch
}

# Synopsis: Build the nuget packages.
task BuildNugetPackage -If ($Configuration -eq 'Release') Init, {
    New-Item $NugetPackageOutputDir -ItemType Directory -Force | Out-Null

    "$RootDir\nuspec\*.nuspec" | Resolve-Path | ForEach {
        exec {
            & $NugetExe pack $_ `
                -version $NugetPackageVersion `
                -OutputDirectory $NugetPackageOutputDir `
                -BasePath $RootDir `
                -NoPackageAnalysis
        }
    }
}

task PublishNugetPackage {
    assert ($NugetFeedUrl) '$NugetFeedUrl is missing. Cannot publish nuget packages'
    assert ($NugetFeedApiKey) '$NugetFeedApiKey is missing. Cannot publish nuget packages'
  
    Get-ChildItem "$RootDir\nugetpackages\" -Filter "*.nupkg" | ForEach-Object {
      $OldErrorActionPreference = $ErrorActionPreference
      $ErrorActionPreference = "SilentlyContinue"
      & $NugetExe push $_.FullName -Source $NugetFeedUrl -ApiKey $NugetFeedApiKey
      $ErrorActionPreference = $OldErrorActionPreference

      if ($LASTEXITCODE -ne 0) {
        if ($Error[0].Exception.Message.Contains("Response status code does not indicate success: 409")) {
          Write-Host "The NuGet feed already contains this package."
        }
        else {
          throw $Error[0].Exception
        }
      }
    }
  }


# Synopsis: A task that makes sure our initialization tasks have been run before we can do anything useful
task Init CreateFolders, GenerateVersionInformation

# Synopsis: Build the project.
task Build Init, BuildNugetPackage, PublishNugetPackage

# Synopsis: By default, Call the 'Build' task
task . Build
