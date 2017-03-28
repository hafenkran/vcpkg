#include "pch.h"
#include "vcpkg_Environment.h"
#include "vcpkg_Commands.h"
#include "vcpkg_System.h"
#include "vcpkg_Strings.h"
#include "vcpkg_Files.h"

namespace vcpkg::Environment
{
    static std::vector<std::string> get_VS2017_installation_instances(const vcpkg_paths& paths)
    {
        const fs::path script = paths.scripts / "findVisualStudioInstallationInstances.ps1";
        const std::wstring cmd = System::create_powershell_script_cmd(script);
        System::exit_code_and_output ec_data = System::cmd_execute_and_capture_output(cmd);
        Checks::check_exit(VCPKG_LINE_INFO, ec_data.exit_code == 0, "Could not run script to detect VS 2017 instances");
        return Strings::split(ec_data.output, "\n");
    }

    static optional<fs::path> find_vs2015_installation_instance()
    {
        const optional<std::wstring> vs2015_cmntools_optional = System::get_environmental_variable(L"VS140COMNTOOLS");
        if (auto v = vs2015_cmntools_optional.get())
        {
            static const fs::path vs2015_cmntools = fs::path(*v).parent_path(); // The call to parent_path() is needed because the env variable has a trailing backslash
            static const fs::path vs2015_path = vs2015_cmntools.parent_path().parent_path();
            return vs2015_path;
        }

        return nullopt;
    }

    static const optional<fs::path>& get_VS2015_installation_instance()
    {
        static const optional<fs::path> vs2015_path = find_vs2015_installation_instance();
        return vs2015_path;
    }

    static fs::path find_dumpbin_exe(const vcpkg_paths& paths)
    {
        const std::vector<std::string> vs2017_installation_instances = get_VS2017_installation_instances(paths);
        std::vector<fs::path> paths_examined;

        // VS2017
        for (const std::string& instance : vs2017_installation_instances)
        {
            const fs::path msvc_path = Strings::format(R"(%s\VC\Tools\MSVC)", instance);
            std::vector<fs::path> msvc_subdirectories;
            Files::non_recursive_find_matching_paths_in_dir(msvc_path, [&](const fs::path& current)
                                                            {
                                                                return fs::is_directory(current);
                                                            }, &msvc_subdirectories);

            // Sort them so that latest comes first
            std::sort(msvc_subdirectories.begin(), msvc_subdirectories.end(), [&](const fs::path& left, const fs::path& right)
                      {
                          return left.filename() > right.filename();
                      });

            for (const fs::path& subdir : msvc_subdirectories)
            {
                const fs::path dumpbin_path = subdir / "bin" / "HostX86" / "x86" / "dumpbin.exe";
                paths_examined.push_back(dumpbin_path);
                if (fs::exists(dumpbin_path))
                {
                    return dumpbin_path;
                }
            }
        }

        // VS2015
        const optional<fs::path>& vs_2015_installation_instance = get_VS2015_installation_instance();
        if (auto v = vs_2015_installation_instance.get())
        {
            const fs::path vs2015_dumpbin_exe = *v / "VC" / "bin" / "dumpbin.exe";
            paths_examined.push_back(vs2015_dumpbin_exe);
            if (fs::exists(vs2015_dumpbin_exe))
            {
                return vs2015_dumpbin_exe;
            }
        }

        System::println(System::color::error, "Could not detect dumpbin.exe.");
        System::println("The following paths were examined:");
        for (const fs::path& path : paths_examined)
        {
            System::println("    %s", path.generic_string());
        }
        Checks::exit_fail(VCPKG_LINE_INFO);
    }

    const fs::path& get_dumpbin_exe(const vcpkg_paths& paths)
    {
        static const fs::path dumpbin_exe = find_dumpbin_exe(paths);
        return dumpbin_exe;
    }

    static vcvarsall_and_platform_toolset find_vcvarsall_bat(const vcpkg_paths& paths)
    {
        const std::vector<std::string> vs2017_installation_instances = get_VS2017_installation_instances(paths);
        std::vector<fs::path> paths_examined;

        // VS2017
        for (const fs::path& instance : vs2017_installation_instances)
        {
            const fs::path vcvarsall_bat = instance / "VC" / "Auxiliary" / "Build" / "vcvarsall.bat";
            paths_examined.push_back(vcvarsall_bat);
            if (fs::exists(vcvarsall_bat))
            {
                return { vcvarsall_bat , L"v141" };
            }
        }

        // VS2015
        const optional<fs::path>& vs_2015_installation_instance = get_VS2015_installation_instance();
        if (auto v = vs_2015_installation_instance.get())
        {
            const fs::path vs2015_vcvarsall_bat = *v / "VC" / "vcvarsall.bat";

            paths_examined.push_back(vs2015_vcvarsall_bat);
            if (fs::exists(vs2015_vcvarsall_bat))
            {
                return { vs2015_vcvarsall_bat, L"v140" };
            }
        }

        System::println(System::color::error, "Could not detect vcvarsall.bat.");
        System::println("The following paths were examined:");
        for (const fs::path& path : paths_examined)
        {
            System::println("    %s", path.generic_string());
        }
        Checks::exit_fail(VCPKG_LINE_INFO);
    }

    const vcvarsall_and_platform_toolset& get_vcvarsall_bat(const vcpkg_paths& paths)
    {
        static const vcvarsall_and_platform_toolset vcvarsall_bat = find_vcvarsall_bat(paths);
        return vcvarsall_bat;
    }

    static const fs::path& get_ProgramFiles()
    {
        static const fs::path p = System::get_environmental_variable(L"PROGRAMFILES").get_or_exit(VCPKG_LINE_INFO);
        return p;
    }

    const fs::path& get_ProgramFiles_32_bit()
    {
        static const fs::path p = []() -> fs::path
            {
                auto value = System::get_environmental_variable(L"ProgramFiles(x86)");
                if (auto v = value.get())
                {
                    return std::move(*v);
                }
                return get_ProgramFiles();
            }();
        return p;
    }

    const fs::path& get_ProgramFiles_platform_bitness()
    {
        static const fs::path p = []() -> fs::path
            {
                auto value = System::get_environmental_variable(L"ProgramW6432");
                if (auto v = value.get())
                {
                    return std::move(*v);
                }
                return get_ProgramFiles();
            }();
        return p;
    }
}
