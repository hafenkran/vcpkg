#Requires -Version 6.0
Set-StrictMode -Version 2

<#
.SYNOPSIS
Returns whether the specified command exists in the current environment.

.DESCRIPTION
Get-CommandExists takes a string as a parameter,
and returns whether it exists in the current environment;
either a function, alias, or an executable in the path.
It's somewhat equivalent to `which`.

.PARAMETER Name
Specifies the name of the command which may or may not exist.

.INPUTS
System.String
    The name of the command.

.OUTPUTS
System.Boolean
    Whether the command exists.
#>
function Get-CommandExists
{
    [CmdletBinding()]
    [OutputType([Boolean])]
    Param(
        [Parameter(ValueFromPipeline)]
        [String]$Name
    )

    $null -ne (Get-Command -Name $Command -ErrorAction SilentlyContinue)
}

<#
.SYNOPSIS
Downloads a file and checks its hash.

.DESCRIPTION
Get-RemoteFile takes a URI and a hash,
downloads the file at that URI to OutFile,
and checks that the hash of the downloaded file.
It then returns a FileInfo object corresponding to the downloaded file.

.PARAMETER OutFile
Specifies the file path to download to.

.PARAMETER Uri
The URI to download from.

.PARAMETER Sha256
The expected SHA256 of the downloaded file.

.INPUTS
None

.OUTPUTS
System.IO.FileInfo
    The FileInfo for the downloaded file.
#>
function Get-RemoteFile
{
    [CmdletBinding(PositionalBinding=$False)]
    [OutputType([System.IO.FileInfo])]
    Param(
        [Parameter(Mandatory=$True)]
        [String]$OutFile,
        [Parameter(Mandatory=$True)]
        [String]$Uri,
        [Parameter(Mandatory=$True)]
        [String]$Sha256
    )

    Invoke-WebRequest -OutFile $OutFile -Uri $Uri
    $actualHash = Get-FileHash -Algorithm SHA256 -Path $OutFile

    if ($actualHash.Hash -ne $Sha256) {
        throw @"
Invalid hash for file $OutFile;
    expected: $Hash
    found:    $($actualHash.Hash)
Please make sure that the hash in the powershell file is correct.
"@
    }

    Get-Item $OutFile
}

<#
.SYNOPSIS
Gets the list of installed extensions as powershell objects.

.DESCRIPTION
Get-InstalledVirtualBoxExtensionPacks gets the installed extensions,
returning objects that look like:

{
    Pack = 'Oracle VM VirtualBox Extension Pack';
    Version = '6.1.10';
    ...
}

.INPUTS
None

.OUTPUTS
PSCustomObject
    The list of VBox Extension objects that are installed.
#>
function Get-InstalledVirtualBoxExtensionPacks
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param()

    $lines = VBoxManage list extpacks

    $result = @()

    $currentObject = $null
    $currentKey = ""
    $currentString = ""

    $lines | ForEach-Object {
        if ($Line[0] -eq ' ') {
            $currentString += "`n$($Line.Trim())"
        } else {
            if ($null -ne $currentObject) {
                $currentObject.$currentKey = $currentString
            }
            $currentKey, $currentString = $Line -Split ':'
            $currentString = $currentString.Trim()

            if ($currentKey.StartsWith('Pack no')) {
                $currentKey = 'Pack'
                if ($null -ne $currentObject) {
                    Write-Output ([PSCustomObject]$currentObject)
                }
                $currentObject = @{}
            }
        }
    }

    if ($null -ne $currentObject) {
        $currentObject.$currentKey = $currentString
        Write-Output ([PSCustomObject]$currentObject)
    }
}
