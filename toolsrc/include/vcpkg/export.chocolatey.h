#pragma once

#include <vcpkg/fwd/vcpkgpaths.h>

#include <vcpkg/dependencies.h>

#include <vector>

namespace vcpkg::Export::Chocolatey
{
    struct Options
    {
        Optional<std::string> maybe_maintainer;
        Optional<std::string> maybe_version_suffix;
    };

    void do_export(const std::vector<Dependencies::ExportPlanAction>& export_plan,
                   const VcpkgPaths& paths,
                   const Options& chocolatey_options);
}
