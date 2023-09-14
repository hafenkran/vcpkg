[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$SourcesRef,
    [Parameter(Mandatory=$false)][string]$PortDirectory = $PSScriptRoot,
    [Parameter(Mandatory=$false)][string]$vcpkg = "$PSScriptRoot/../../vcpkg"
)

$ErrorActionPreference = "Stop"

$ManifestIn = "$PortDirectory/vcpkg.in.json"
$ManifestOut = "$PortDirectory/vcpkg.json"
$CMakeFragmentFile = "$PortDirectory/compute_build_only.cmake"

$ExtractedSources = "${env:TEMP}/aws-sdk-cpp-generateFeatures-$SourcesRef"
if (-not (Test-Path $ExtractedSources)) {
    if (Test-Path "$ExtractedSources.tmp") {
        Remove-Item -Force "$ExtractedSources.tmp"
    }
    git clone "https://github.com/aws/aws-sdk-cpp" "$ExtractedSources.tmp" | Out-Host
    git -c "$ExtractedSources.tmp" checkout $SourcesRef
    Move-Item "$ExtractedSources.tmp" "$ExtractedSources"
}
Write-Host "Using sources directory: $ExtractedSources"


$subfolders = Get-ChildItem -Path "$ExtractedSources\generated\src\aws-cpp-sdk-*", "$ExtractedSources\src\aws-cpp-sdk*" | Sort-Object -Property Name

$manifest = Get-Content $ManifestIn | ConvertFrom-Json
$manifest | Add-Member `
    -NotePropertyName '$note' `
    -NotePropertyValue 'Automatically generated by generateFeatures.ps1'
$manifest | Add-Member -NotePropertyName 'features' -NotePropertyValue @{}

$cmakefragmenttext = @("# Automatically generated by generateFeatures.ps1")

function GetDescription($dir, $modulename)
{
    if (Test-Path "$dir\CMakeLists.txt")
    {
        $descs = @(Select-String -Path "$dir\CMakeLists.txt" -Pattern "`"C\+\+ SDK for the AWS [^`"]*`"")
        if ($descs.count -eq 1) {
            $desc = $descs[0].Matches.Value -replace "`"",""
            "$desc"
        }
        else { "C++ SDK for the AWS $modulename service" }
    }
    else { "C++ SDK for the AWS $modulename service" }
}

$featureDependencies = @{}
Select-String -Path "$ExtractedSources\cmake\sdksCommon.cmake" -Pattern "list\(APPEND SDK_DEPENDENCY_LIST `"([\w-]+):([\w-,]+)`"\)" -AllMatches `
| ForEach-Object { $_.Matches } `
| ForEach-Object { $featureDependencies[$_.Groups[1].Value] = @($_.Groups[2].Value -split "," `
| Where-Object { $_ -ne "core" }) }

foreach ($subfolder in $subfolders)
{
    $modulename = $subfolder.name -replace "^aws-cpp-sdk-",""
    if ($modulename -match "-tests`$") { continue }
    if ($modulename -match "-sample`$") { continue }
    if ($modulename -eq "core") { continue }

    $lowermodulename = $modulename.ToLower()

    $featureObj = @{ description = (GetDescription $subfolder $modulename) }

    if ($featureDependencies.ContainsKey($lowermodulename)) {
        $featureObj.dependencies = ,@{ name = "aws-sdk-cpp"; "default-features" = $false; "features" = $featureDependencies[$lowermodulename] }
    }

    $manifest.features.Add("$lowermodulename", $featureObj)

    $cmakefragmenttext += @(
        "if(`"$lowermodulename`" IN_LIST FEATURES)",
        "  list(APPEND BUILD_ONLY $modulename)",
        "endif()"
    )
}

[IO.File]::WriteAllText($ManifestOut, (ConvertTo-Json -Depth 10 -InputObject $manifest))

Write-Verbose ($cmakefragmenttext -join "`n")
[IO.File]::WriteAllText($CMakeFragmentFile, ($cmakefragmenttext -join "`n") +"`n")

& $vcpkg format-manifest --feature-flags=-manifests $ManifestOut
