[CmdletBinding()]
param(
    [ValidateNotNullOrEmpty()][string]$disableMetrics = "0",
    [Parameter(Mandatory=$False)][string]$withVSPath = ""
)
Set-StrictMode -Version Latest
$scriptsDir = split-path -parent $script:MyInvocation.MyCommand.Definition
. "$scriptsDir\VcpkgPowershellUtils.ps1"

$vcpkgRootDir = $scriptsDir
$withVSPath = $withVSPath -replace "\\$" # Remove potential trailing backslash

while (!($vcpkgRootDir -eq "") -and !(Test-Path "$vcpkgRootDir\.vcpkg-root"))
{
    Write-Verbose "Examining $vcpkgRootDir for .vcpkg-root"
    $vcpkgRootDir = Split-path $vcpkgRootDir -Parent
}
Write-Verbose "Examining $vcpkgRootDir for .vcpkg-root - Found"

$gitHash = "nohash"
$vcpkgSourcesPath = "$vcpkgRootDir\toolsrc"

if (!(Test-Path $vcpkgSourcesPath))
{
    Write-Error "Unable to determine vcpkg sources directory. '$vcpkgSourcesPath' does not exist."
    return
}

function findAnyMSBuildWithCppPlatformToolset([string]$withVSPath)
{
    $VisualStudioInstances = & $scriptsDir\getVisualStudioInstances.ps1
    if ($VisualStudioInstances -eq $null)
    {
        throw "Could not find Visual Studio. VS2015 or VS2017 (with C++) needs to be installed."
    }

    Write-Verbose "VS Candidates:`n`r$([system.String]::Join([Environment]::NewLine, $VisualStudioInstances))"
    foreach ($instanceCandidateWithEOL in $VisualStudioInstances)
    {
        $instanceCandidate = $instanceCandidateWithEOL -replace "<sol>::" -replace "::<eol>"
        Write-Verbose "Inspecting: $instanceCandidate"
        $split = $instanceCandidate -split "::"
        # $preferenceWeight = $split[0]
        # $releaseType = $split[1]
        $version = $split[2]
        $path = $split[3]

        if ($withVSPath -ne "" -and $withVSPath -ne $path)
        {
            Write-Verbose "Skipping: $instanceCandidate"
            continue
        }

        $majorVersion = $version.Substring(0,2);
        if ($majorVersion -eq "15")
        {
            $VCFolder= "$path\VC\Tools\MSVC\"
            if (Test-Path $VCFolder)
            {
                Write-Verbose "Picking: $instanceCandidate"
                return "$path\MSBuild\15.0\Bin\MSBuild.exe", "v141"
            }
        }

        if ($majorVersion -eq "14")
        {
            $clExe= "$path\VC\bin\cl.exe"
            if (Test-Path $clExe)
            {
                Write-Verbose "Picking: $instanceCandidate"
                $programFilesPath = getProgramFiles32bit
                return "$programFilesPath\MSBuild\14.0\Bin\MSBuild.exe", "v140"
            }
        }
    }

    throw "Could not find MSBuild version with C++ support. VS2015 or VS2017 (with C++) needs to be installed."
}
function getWindowsSDK( [Parameter(Mandatory=$False)][switch]$DisableWin10SDK = $False,
                        [Parameter(Mandatory=$False)][switch]$DisableWin81SDK = $False)
{
    if ($DisableWin10SDK -and $DisableWin81SDK)
    {
        throw "Both Win10SDK and Win81SDK were disabled."
    }

    Write-Verbose "Finding WinSDK"

    $validInstances = New-Object System.Collections.ArrayList

    # Windows 10 SDK
    function CheckWindows10SDK($path)
    {
        if ($path -eq $null)
        {
            return
        }

        $folder = (Join-Path $path "Include")
        if (!(Test-Path $folder))
        {
            Write-Verbose "$folder - Not Found"
            return
        }

        Write-Verbose "$folder - Found"
        $win10sdkVersions = @(Get-ChildItem $folder | Where-Object {$_.Name -match "^10"} | Sort-Object)
        [array]::Reverse($win10sdkVersions) # Newest SDK first

        foreach ($win10sdkV in $win10sdkVersions)
        {
            $windowsheader = "$folder\$win10sdkV\um\windows.h"
            if (!(Test-Path $windowsheader))
            {
                Write-Verbose "$windowsheader - Not Found"
                continue
            }
            Write-Verbose "$windowsheader - Found"

            $ddkheader = "$folder\$win10sdkV\shared\sdkddkver.h"
            if (!(Test-Path $ddkheader))
            {
                Write-Verbose "$ddkheader - Not Found"
                continue
            }

            Write-Verbose "$ddkheader - Found"
            $win10sdkVersionString = $win10sdkV.ToString()
            Write-Verbose "Found $win10sdkVersionString"
            $validInstances.Add($win10sdkVersionString) > $null
        }
    }

    Write-Verbose "`n"
    Write-Verbose "Looking for Windows 10 SDK"
    $regkey10 = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Kits\Installed Roots\' -Name 'KitsRoot10' -ErrorAction SilentlyContinue
    $regkey10Wow6432 = Get-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows Kits\Installed Roots\' -Name 'KitsRoot10' -ErrorAction SilentlyContinue
    if (vcpkgHasProperty -object $regkey10 "KitsRoot10") { CheckWindows10SDK($regkey10.KitsRoot10) }
    if (vcpkgHasProperty -object $regkey10Wow6432 "KitsRoot10") { CheckWindows10SDK($regkey10Wow6432.KitsRoot10) }
    CheckWindows10SDK("$env:ProgramFiles\Windows Kits\10")
    CheckWindows10SDK("${env:ProgramFiles(x86)}\Windows Kits\10")

    # Windows 8.1 SDK
    function CheckWindows81SDK($path)
    {
        if ($path -eq $null)
        {
            return
        }

        $folder = "$path\Include"
        if (!(Test-Path $folder))
        {
            Write-Verbose "$folder - Not Found"
            return
        }

        Write-Verbose "$folder - Found"
        $win81sdkVersionString = "8.1"
        Write-Verbose "Found $win81sdkVersionString"
        $validInstances.Add($win81sdkVersionString) > $null
    }

    Write-Verbose "`n"
    Write-Verbose "Looking for Windows 8.1 SDK"
    $regkey81 = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Kits\Installed Roots\' -Name 'KitsRoot81' -ErrorAction SilentlyContinue
    $regkey81Wow6432 = Get-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows Kits\Installed Roots\' -Name 'KitsRoot81' -ErrorAction SilentlyContinue
    if (vcpkgHasProperty -object $regkey81 "KitsRoot81") { CheckWindows81SDK($regkey81.KitsRoot81) }
    if (vcpkgHasProperty -object $regkey81Wow6432 "KitsRoot81") { CheckWindows81SDK($regkey81Wow6432.KitsRoot81) }
    CheckWindows81SDK("$env:ProgramFiles\Windows Kits\8.1")
    CheckWindows81SDK("${env:ProgramFiles(x86)}\Windows Kits\8.1")

    Write-Verbose "`n`n`n"
    Write-Verbose "The following Windows SDKs were found:"
    foreach ($instance in $validInstances)
    {
        Write-Verbose $instance
    }

    # Selecting
    foreach ($instance in $validInstances)
    {
        if (!$DisableWin10SDK -and $instance -match "10.")
        {
            return $instance
        }

        if (!$DisableWin81SDK -and $instance -match "8.1")
        {
            return $instance
        }
    }

    throw "Could not detect a Windows SDK / TargetPlatformVersion"
}

$msbuildExeWithPlatformToolset = findAnyMSBuildWithCppPlatformToolset $withVSPath
$msbuildExe = $msbuildExeWithPlatformToolset[0]
$platformToolset = $msbuildExeWithPlatformToolset[1]
$windowsSDK = getWindowsSDK

$arguments = (
"`"/p:VCPKG_VERSION=-$gitHash`"",
"`"/p:DISABLE_METRICS=$disableMetrics`"",
"/p:Configuration=Release",
"/p:Platform=x86",
"/p:PlatformToolset=$platformToolset",
"/p:TargetPlatformVersion=$windowsSDK",
"/verbosity:minimal",
"/m",
"/nologo",
"`"$vcpkgSourcesPath\dirs.proj`"") -join " "

function vcpkgInvokeCommandClean()
{
    param ( [Parameter(Mandatory=$true)][string]$executable,
                                        [string]$arguments = "")

    Write-Verbose "Clean-Executing: ${executable} ${arguments}"
    $scriptsDir = split-path -parent $script:MyInvocation.MyCommand.Definition
    $cleanEnvScript = "$scriptsDir\VcpkgPowershellUtils-ClearEnvironment.ps1"
    $tripleQuotes = "`"`"`""
    $argumentsWithEscapedQuotes = $arguments -replace "`"", $tripleQuotes
    $command = ". $tripleQuotes$cleanEnvScript$tripleQuotes; & $tripleQuotes$executable$tripleQuotes $argumentsWithEscapedQuotes"
    $arg = "-NoProfile", "-ExecutionPolicy Bypass", "-command $command"

    $process = Start-Process -FilePath powershell.exe -ArgumentList $arg -PassThru -NoNewWindow
    Wait-Process -InputObject $process
    $ec = $process.ExitCode
    Write-Verbose "Execution terminated with exit code $ec."
    return $ec
}

# vcpkgInvokeCommandClean cmd "/c echo %PATH%"
Write-Host "`nBuilding vcpkg.exe ...`n"
$ec = vcpkgInvokeCommandClean $msbuildExe $arguments

if ($ec -ne 0)
{
    Write-Error "Building vcpkg.exe failed. Please ensure you have installed Visual Studio with the Desktop C++ workload and the Windows SDK for Desktop C++."
    return
}
Write-Host "`nBuilding vcpkg.exe... done.`n"

Write-Verbose("Placing vcpkg.exe in the correct location")

Copy-Item $vcpkgSourcesPath\Release\vcpkg.exe $vcpkgRootDir\vcpkg.exe | Out-Null
Copy-Item $vcpkgSourcesPath\Release\vcpkgmetricsuploader.exe $vcpkgRootDir\scripts\vcpkgmetricsuploader.exe | Out-Null
