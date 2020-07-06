[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)]
    [string]$Toolsrc,
    [Parameter()]
    [switch]$IgnoreErrors # allows one to just format
)

$clangFormat = 'C:\Program Files\LLVM\bin\clang-format.exe'
if (-not (Test-Path $clangFormat))
{
    Write-Error "clang-format not found; is it installed in the CI machines?"
    throw
}

$Toolsrc = Get-Item $Toolsrc
Push-Location $Toolsrc

try
{
    $files = Get-ChildItem -Recurse -LiteralPath "$Toolsrc/src" -Filter '*.cpp'
    $files += Get-ChildItem -Recurse -LiteralPath "$Toolsrc/include/vcpkg" -Filter '*.h'
    $files += Get-ChildItem -Recurse -LiteralPath "$Toolsrc/include/vcpkg-test" -Filter '*.h'
    $files += Get-Item "$Toolsrc/include/pch.h"
    $fileNames = $files.FullName

    & $clangFormat -style=file -i @fileNames

    $changedFiles = git status --porcelain $Toolsrc | ForEach-Object {
        (-split $_)[1]
    }

    if (-not $IgnoreErrors -and $null -ne $changedFiles)
    {
        $msg = @(
            "",
            "The formatting of the C++ files didn't match our expectation.",
            "If your build fails here, you need to format the following files with:"
        )
        $msg += "    $(& $clangFormat -version)"
        $msg += "    $changedFiles"
        $msg += ""

        $msg += "clang-format should produce the following diff:"
        $msg += git diff $Toolsrc

        Write-Error ($msg -join "`n")
        throw
    }
}
finally
{
    Pop-Location
}
