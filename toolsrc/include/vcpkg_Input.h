#pragma once
#include <vector>
#include "PackageSpec.h"
#include "vcpkg_paths.h"

namespace vcpkg::Input
{
    PackageSpec check_and_get_package_spec(
        const std::string& package_spec_as_string,
        const triplet& default_target_triplet,
        CStringView example_text);

    void check_triplet(const triplet& t, const vcpkg_paths& paths);
}
