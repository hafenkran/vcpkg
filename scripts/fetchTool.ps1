[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$tool
)

Set-StrictMode -Version Latest
$scriptsDir = split-path -parent $script:MyInvocation.MyCommand.Definition
. "$scriptsDir\VcpkgPowershellUtils.ps1"

Write-Verbose "Fetching tool: $tool"
$vcpkgRootDir = vcpkgFindFileRecursivelyUp $scriptsDir .vcpkg-root

$downloadsDir = "$vcpkgRootDir\downloads"
vcpkgCreateDirectoryIfNotExists $downloadsDir

$tool = $tool.toLower()

[xml]$asXml = Get-Content "$scriptsDir\vcpkgTools.xml"
$toolData = $asXml.SelectSingleNode("//tools/tool[@name=`"$tool`"]") # Case-sensitive!

if ($toolData -eq $null)
{
    throw "Unkown tool $tool"
}

$exePath = "$downloadsDir\$($toolData.exeRelativePath)"

if (Test-Path $exePath)
{
    return $exePath
}

$isArchive = vcpkgHasProperty -object $toolData -propertyName "archiveRelativePath"
if ($isArchive)
{
    $downloadPath = "$downloadsDir\$($toolData.archiveRelativePath)"
}
else
{
    $downloadPath = "$downloadsDir\$($toolData.exeRelativePath)"
}

[String]$url = $toolData.url
if (!(Test-Path $downloadPath))
{
    Write-Host "Downloading $tool..."
    vcpkgDownloadFile $url $downloadPath
    Write-Host "Downloading $tool... done."
}

$expectedDownloadedFileHash = $toolData.sha256
$downloadedFileHash = vcpkgGetSHA256 $downloadPath
vcpkgCheckEqualFileHash -filePath $downloadPath -expectedHash $expectedDownloadedFileHash -actualHash $downloadedFileHash

if ($isArchive)
{
    $outFilename = (Get-ChildItem $downloadPath).BaseName
    Write-Host "Extracting $tool..."
    vcpkgExtractFile -ArchivePath $downloadPath -DestinationDir $downloadsDir -outFilename $outFilename
    Write-Host "Extracting $tool... done."
}

if (-not (Test-Path $exePath))
{
    Write-Error "Could not detect or download $tool"
    throw
}

return "<sol>::$exePath::<eol>"
