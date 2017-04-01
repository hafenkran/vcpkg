#include "pch.h"
#include "vcpkg_expected.h"
#include "vcpkg_paths.h"
#include "metrics.h"
#include "vcpkg_System.h"
#include "package_spec.h"
#include "vcpkg_Files.h"

namespace vcpkg
{
    static bool exists_and_has_equal_or_greater_version(const std::wstring& version_cmd, const std::array<int, 3>& expected_version)
    {
        static const std::regex re(R"###((\d+)\.(\d+)\.(\d+))###");

        auto rc = System::cmd_execute_and_capture_output(Strings::wformat(LR"(%s)", version_cmd));
        if (rc.exit_code != 0)
        {
            return false;
        }

        std::match_results<std::string::const_iterator> match;
        auto found = std::regex_search(rc.output, match, re);
        if (!found)
        {
            return false;
        }

        int d1 = atoi(match[1].str().c_str());
        int d2 = atoi(match[2].str().c_str());
        int d3 = atoi(match[3].str().c_str());
        if (d1 > expected_version[0] || (d1 == expected_version[0] && d2 > expected_version[1]) || (d1 == expected_version[0] && d2 == expected_version[1] && d3 >= expected_version[2]))
        {
            // satisfactory version found
            return true;
        }

        return false;
    }

    static optional<fs::path> find_if_has_equal_or_greater_version(const std::vector<fs::path>& candidate_paths, const std::wstring& version_check_arguments, const std::array<int, 3>& expected_version)
    {
        auto it = std::find_if(candidate_paths.cbegin(), candidate_paths.cend(), [&](const fs::path& p)
                               {
                                   const std::wstring cmd = Strings::wformat(LR"("%s" %s)", p.native(), version_check_arguments);
                                   return exists_and_has_equal_or_greater_version(cmd, expected_version);
                               });

        if (it != candidate_paths.cend())
        {
            return std::move(*it);
        }

        return nullopt;
    }

    static std::vector<fs::path> find_from_PATH(const std::wstring& name)
    {
        const std::wstring cmd = Strings::wformat(L"where.exe %s", name);
        auto out = System::cmd_execute_and_capture_output(cmd);
        if (out.exit_code != 0)
        {
            return {};
        }

        const std::vector<std::string> paths_to_add = Strings::split(out.output, "\n");
        std::vector<fs::path> v;
        v.insert(v.end(), paths_to_add.cbegin(), paths_to_add.cend());
        return v;
    }

    static fs::path fetch_dependency(const fs::path scripts_folder, const std::wstring& tool_name, const fs::path& expected_downloaded_path)
    {
        const fs::path script = scripts_folder / "fetchDependency.ps1";
        auto install_cmd = System::create_powershell_script_cmd(script, Strings::wformat(L"-Dependency %s", tool_name));
        System::exit_code_and_output rc = System::cmd_execute_and_capture_output(install_cmd);
        if (rc.exit_code)
        {
            System::println(System::color::error, "Launching powershell failed or was denied");
            TrackProperty("error", "powershell install failed");
            TrackProperty("installcmd", install_cmd);
            Checks::exit_with_code(VCPKG_LINE_INFO, rc.exit_code);
        }

        const fs::path actual_downloaded_path = Strings::trimmed(rc.output);
        Checks::check_exit(VCPKG_LINE_INFO, expected_downloaded_path == actual_downloaded_path, "Expected dependency downloaded path to be %s, but was %s",
                                          expected_downloaded_path.generic_string(), actual_downloaded_path.generic_string());
        return actual_downloaded_path;
    }

    static fs::path get_cmake_path(const fs::path& downloads_folder, const fs::path scripts_folder)
    {
        static constexpr std::array<int, 3> expected_version = { 3,8,0 };
        static const std::wstring version_check_arguments = L"--version";

        const fs::path downloaded_copy = downloads_folder / "cmake-3.8.0-rc1-win32-x86" / "bin" / "cmake.exe";
        const std::vector<fs::path> from_path = find_from_PATH(L"cmake");

        std::vector<fs::path> candidate_paths;
        candidate_paths.push_back(downloaded_copy);
        candidate_paths.insert(candidate_paths.end(), from_path.cbegin(), from_path.cend());
        candidate_paths.push_back(System::get_ProgramFiles_platform_bitness() / "CMake" / "bin" / "cmake.exe");
        candidate_paths.push_back(System::get_ProgramFiles_32_bit() / "CMake" / "bin");

        const optional<fs::path> path = find_if_has_equal_or_greater_version(candidate_paths, version_check_arguments, expected_version);
        if (auto p = path.get())
        {
            return *p;
        }

        return fetch_dependency(scripts_folder, L"cmake", downloaded_copy);
    }

    fs::path get_nuget_path(const fs::path& downloads_folder, const fs::path scripts_folder)
    {
        static constexpr std::array<int, 3> expected_version = { 3,3,0 };
        static const std::wstring version_check_arguments = L"";

        const fs::path downloaded_copy = downloads_folder / "nuget-3.5.0" / "nuget.exe";
        const std::vector<fs::path> from_path = find_from_PATH(L"nuget");

        std::vector<fs::path> candidate_paths;
        candidate_paths.push_back(downloaded_copy);
        candidate_paths.insert(candidate_paths.end(), from_path.cbegin(), from_path.cend());

        auto path = find_if_has_equal_or_greater_version(candidate_paths, version_check_arguments, expected_version);
        if (auto p = path.get())
        {
            return *p;
        }

        return fetch_dependency(scripts_folder, L"nuget", downloaded_copy);
    }

    fs::path get_git_path(const fs::path& downloads_folder, const fs::path scripts_folder)
    {
        static constexpr std::array<int, 3> expected_version = { 2,0,0 };
        static const std::wstring version_check_arguments = L"--version";

        const fs::path downloaded_copy = downloads_folder / "MinGit-2.11.1-32-bit" / "cmd" / "git.exe";
        const std::vector<fs::path> from_path = find_from_PATH(L"git");

        std::vector<fs::path> candidate_paths;
        candidate_paths.push_back(downloaded_copy);
        candidate_paths.insert(candidate_paths.end(), from_path.cbegin(), from_path.cend());
        candidate_paths.push_back(System::get_ProgramFiles_platform_bitness() / "git" / "cmd" / "git.exe");
        candidate_paths.push_back(System::get_ProgramFiles_32_bit() / "git" / "cmd" / "git.exe");

        const optional<fs::path> path = find_if_has_equal_or_greater_version(candidate_paths, version_check_arguments, expected_version);
        if (auto p = path.get())
        {
            return *p;
        }

        return fetch_dependency(scripts_folder, L"git", downloaded_copy);
    }

    expected<vcpkg_paths> vcpkg_paths::create(const fs::path& vcpkg_root_dir)
    {
        std::error_code ec;
        const fs::path canonical_vcpkg_root_dir = fs::canonical(vcpkg_root_dir, ec);
        if (ec)
        {
            return ec;
        }

        vcpkg_paths paths;
        paths.root = canonical_vcpkg_root_dir;

        if (paths.root.empty())
        {
            TrackProperty("error", "Invalid vcpkg root directory");
            Checks::exit_with_message(VCPKG_LINE_INFO, "Invalid vcpkg root directory: %s", paths.root.string());
        }

        paths.packages = paths.root / "packages";
        paths.buildtrees = paths.root / "buildtrees";
        paths.downloads = paths.root / "downloads";
        paths.ports = paths.root / "ports";
        paths.installed = paths.root / "installed";
        paths.triplets = paths.root / "triplets";
        paths.scripts = paths.root / "scripts";

        paths.buildsystems = paths.scripts / "buildsystems";
        paths.buildsystems_msbuild_targets = paths.buildsystems / "msbuild" / "vcpkg.targets";

        paths.vcpkg_dir = paths.installed / "vcpkg";
        paths.vcpkg_dir_status_file = paths.vcpkg_dir / "status";
        paths.vcpkg_dir_info = paths.vcpkg_dir / "info";
        paths.vcpkg_dir_updates = paths.vcpkg_dir / "updates";

        paths.ports_cmake = paths.scripts / "ports.cmake";

        return paths;
    }

    fs::path vcpkg_paths::package_dir(const package_spec& spec) const
    {
        return this->packages / spec.dir();
    }

    fs::path vcpkg_paths::port_dir(const package_spec& spec) const
    {
        return this->ports / spec.name();
    }

    fs::path vcpkg_paths::build_info_file_path(const package_spec& spec) const
    {
        return this->package_dir(spec) / "BUILD_INFO";
    }

    fs::path vcpkg_paths::listfile_path(const BinaryParagraph& pgh) const
    {
        return this->vcpkg_dir_info / (pgh.fullstem() + ".list");
    }

    bool vcpkg_paths::is_valid_triplet(const triplet& t) const
    {
        auto it = fs::directory_iterator(this->triplets);
        for (; it != fs::directory_iterator(); ++it)
        {
            std::string triplet_file_name = it->path().stem().generic_u8string();
            if (t.canonical_name() == triplet_file_name) // TODO: fuzzy compare
            {
                //t.value = triplet_file_name; // NOTE: uncomment when implementing fuzzy compare
                return true;
            }
        }
        return false;
    }

    const fs::path& vcpkg_paths::get_cmake_exe() const
    {
        return this->cmake_exe.get_lazy([this]() { return get_cmake_path(this->downloads, this->scripts); });
    }

    const fs::path& vcpkg_paths::get_git_exe() const
    {
        return this->git_exe.get_lazy([this]() { return get_git_path(this->downloads, this->scripts); });
    }

    const fs::path& vcpkg_paths::get_nuget_exe() const
    {
        return this->nuget_exe.get_lazy([this]() { return get_nuget_path(this->downloads, this->scripts); });
    }

    static std::vector<std::string> get_VS2017_installation_instances(const vcpkg_paths& paths)
    {
        const fs::path script = paths.scripts / "findVisualStudioInstallationInstances.ps1";
        const std::wstring cmd = System::create_powershell_script_cmd(script);
        System::exit_code_and_output ec_data = System::cmd_execute_and_capture_output(cmd);
        Checks::check_exit(VCPKG_LINE_INFO, ec_data.exit_code == 0, "Could not run script to detect VS 2017 instances");
        return Strings::split(ec_data.output, "\n");
    }

    static const optional<fs::path>& get_VS2015_installation_instance()
    {
        static const optional<fs::path> vs2015_path = []() -> optional<fs::path>
            {
                const optional<std::wstring> vs2015_cmntools_optional = System::get_environmental_variable(L"VS140COMNTOOLS");
                if (auto v = vs2015_cmntools_optional.get())
                {
                    static const fs::path vs2015_cmntools = fs::path(*v).parent_path(); // The call to parent_path() is needed because the env variable has a trailing backslash
                    static const fs::path vs2015_path = vs2015_cmntools.parent_path().parent_path();
                    return vs2015_path;
                }

                return nullopt;
            }();
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

    const fs::path& vcpkg_paths::get_dumpbin_exe() const
    {
        static const fs::path dumpbin_exe = find_dumpbin_exe(*this);
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

    const vcvarsall_and_platform_toolset& vcpkg_paths::get_vcvarsall_bat() const
    {
        static const vcvarsall_and_platform_toolset vcvarsall_bat = find_vcvarsall_bat(*this);
        return vcvarsall_bat;
    }
}
