#include "pch.h"

#include <vcpkg/base/system.print.h>
#include <vcpkg/base/system.process.h>
#include <vcpkg/commands.h>
#include <vcpkg/export.h>
#include <vcpkg/export.chocolatey.h>
#include <vcpkg/install.h>

namespace vcpkg::Export::Chocolatey
{
    using Dependencies::ExportPlanAction;
    using Dependencies::ExportPlanType;
    using Install::InstallDir;

    static std::string create_nuspec_dependencies(const BinaryParagraph& binary_paragraph)
    {
        static constexpr auto CONTENT_TEMPLATE =
            R"(<dependency id="@PACKAGE_ID@" version="0.0.0" />)";
        
        std::string nuspec_dependencies;
        for (const std::string& depend: binary_paragraph.depends)
        {
            nuspec_dependencies += Strings::replace_all(CONTENT_TEMPLATE, "@PACKAGE_ID@", depend);
        }
        return nuspec_dependencies;
    }

    static std::string create_nuspec_file_contents(const std::string& exported_root_dir,
                                                   const BinaryParagraph& binary_paragraph)
    {
        static constexpr auto CONTENT_TEMPLATE = R"(
<package>
    <metadata>
        <id>@PACKAGE_ID@</id>
        <version>@PACKAGE_VERSION@</version>
        <authors>@PACKAGE_MAINTAINER@</authors>
        <description><![CDATA[
            @PACKAGE_DESCRIPTION@
        ]]></description>
        <dependencies>
            @PACKAGE_DEPENDENCIES@
        </dependencies>
    </metadata>
    <files>
        <file src="@EXPORTED_ROOT_DIR@\installed\**" target="installed" />
        <file src="@EXPORTED_ROOT_DIR@\tools\**" target="tools" />
    </files>
</package>
)";
        std::string maintainer = binary_paragraph.maintainer;
        if (maintainer.empty())
        {
            maintainer = binary_paragraph.spec.name();
        }
        std::string nuspec_file_content = Strings::replace_all(CONTENT_TEMPLATE, "@PACKAGE_ID@", binary_paragraph.spec.name());
        nuspec_file_content =
            Strings::replace_all(std::move(nuspec_file_content), "@PACKAGE_VERSION@", binary_paragraph.version);
        nuspec_file_content =
            Strings::replace_all(std::move(nuspec_file_content), "@PACKAGE_MAINTAINER@", maintainer);
        nuspec_file_content =
            Strings::replace_all(std::move(nuspec_file_content), "@PACKAGE_DESCRIPTION@", binary_paragraph.description);
        nuspec_file_content =
            Strings::replace_all(std::move(nuspec_file_content), "@EXPORTED_ROOT_DIR@", exported_root_dir);
        nuspec_file_content =
            Strings::replace_all(std::move(nuspec_file_content), "@PACKAGE_DEPENDENCIES@", create_nuspec_dependencies(binary_paragraph));
        return nuspec_file_content;
    }

    static std::string create_chocolatey_install_contents()
    {
        static constexpr auto CONTENT_TEMPLATE = R"###(
$ErrorActionPreference = 'Stop';

$packageName= $env:ChocolateyPackageName
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$rootDir    = "$(Split-Path -parent $toolsDir)"
$installedDir = Join-Path $rootDir 'installed'

$whereToInstall = (pwd).path
$whereToInstallCache = Join-Path $rootDir 'install.txt'
Set-Content -Path $whereToInstallCache -Value $whereToInstall
Copy-Item $installedDir -destination $whereToInstall -recurse -force
)###";
        return CONTENT_TEMPLATE;
    }

    static std::string create_chocolatey_uninstall_contents(const BinaryParagraph& binary_paragraph)
    {
        static constexpr auto CONTENT_TEMPLATE = R"###(
$ErrorActionPreference = 'Stop';

$packageName= $env:ChocolateyPackageName
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$rootDir    = "$(Split-Path -parent $toolsDir)"
$listFile = Join-Path $rootDir 'installed\vcpkg\info\@PACKAGE_FULLSTEM@.list'

$whereToInstall = $null
$whereToInstallCache = Join-Path $rootDir 'install.txt'
Get-Content $whereToInstallCache | Foreach-Object {
    $whereToInstall = $_
}

$installedDir = Join-Path $whereToInstall 'installed'
Get-Content $listFile | Foreach-Object { 
    $fileToRemove = Join-Path $installedDir $_
    if (Test-Path $fileToRemove -PathType Leaf) {
        Remove-Item $fileToRemove
    }
}

Get-Content $listFile | Foreach-Object {
    $fileToRemove = Join-Path $installedDir $_
    if (Test-Path $fileToRemove -PathType Container) {
        $folderToDelete = Join-Path $fileToRemove *
        if (-Not (Test-Path $folderToDelete))
        {
            Remove-Item $fileToRemove
        }
    }
}

$listFileToRemove = Join-Path $whereToInstall 'installed\vcpkg\info\@PACKAGE_FULLSTEM@.list'
Remove-Item $listFileToRemove

if (Test-Path $installedDir)
{
    while (
        $empties = Get-ChildItem $installedDir -recurse -Directory | Where-Object {
            $_.GetFiles().Count -eq 0 -and $_.GetDirectories().Count -eq 0
        }
    ) { $empties | Remove-Item }
}
)###";
        std::string chocolatey_uninstall_content = Strings::replace_all(CONTENT_TEMPLATE, "@PACKAGE_FULLSTEM@", binary_paragraph.fullstem());
        return chocolatey_uninstall_content;
    }

    void do_export(const std::vector<ExportPlanAction>& export_plan,
                   const VcpkgPaths& paths)
    {
        Files::Filesystem& fs = paths.get_filesystem();
        const fs::path vcpkg_root_path = paths.root;
        const fs::path raw_exported_dir_path = vcpkg_root_path / "chocolatey";
        const fs::path& nuget_exe = paths.get_tool_exe(Tools::NUGET);

        std::error_code ec;
        fs.remove_all(raw_exported_dir_path, ec);
        fs.create_directory(raw_exported_dir_path, ec);

        // execute the plan
        for (const ExportPlanAction& action : export_plan)
        {
            if (action.plan_type != ExportPlanType::ALREADY_BUILT)
            {
                Checks::unreachable(VCPKG_LINE_INFO);
            }

            const std::string display_name = action.spec.to_string();
            System::print2("Exporting package ", display_name, "...\n");

            const fs::path per_package_dir_path = raw_exported_dir_path / action.spec.name();

            const BinaryParagraph& binary_paragraph = action.core_paragraph().value_or_exit(VCPKG_LINE_INFO);

            const InstallDir dirs = InstallDir::from_destination_root(
                per_package_dir_path / "installed",
                action.spec.triplet().to_string(),
                per_package_dir_path / "installed" / "vcpkg" / "info" / (binary_paragraph.fullstem() + ".list"));

            Install::install_files_and_write_listfile(paths.get_filesystem(), paths.package_dir(action.spec), dirs);

            const std::string nuspec_file_content =
                create_nuspec_file_contents(per_package_dir_path.string(), binary_paragraph);
            const fs::path nuspec_file_path = per_package_dir_path / Strings::concat(binary_paragraph.spec.name(), ".nuspec");
            fs.write_contents(nuspec_file_path, nuspec_file_content);

            fs.create_directory(per_package_dir_path / "tools", ec);

            const std::string chocolatey_install_content = create_chocolatey_install_contents();
            const fs::path chocolatey_install_file_path = per_package_dir_path / "tools" / "chocolateyInstall.ps1";
            fs.write_contents(chocolatey_install_file_path, chocolatey_install_content);

            const std::string chocolatey_uninstall_content = create_chocolatey_uninstall_contents(binary_paragraph);
            const fs::path chocolatey_uninstall_file_path = per_package_dir_path / "tools" / "chocolateyUninstall.ps1";
            fs.write_contents(chocolatey_uninstall_file_path, chocolatey_uninstall_content);

            const auto cmd_line = Strings::format(R"("%s" pack -OutputDirectory "%s" "%s" -NoDefaultExcludes > nul)",
                                              nuget_exe.u8string(),
                                              vcpkg_root_path.u8string(),
                                              nuspec_file_path.u8string());

            const int exit_code = System::cmd_execute_clean(cmd_line);
            Checks::check_exit(VCPKG_LINE_INFO, exit_code == 0, "Error: NuGet package creation failed");
        }
    }
}
