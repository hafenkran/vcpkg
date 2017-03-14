#include "pch.h"
#include "vcpkg_Enums.h"
#include "vcpkg_Checks.h"

namespace vcpkg::Enums
{
    std::string nullvalue_toString(const std::string& enum_name)
    {
        return Strings::format("%s_NULLVALUE", enum_name);
    }

    __declspec(noreturn) void nullvalue_used(const LineInfo& line_info, const std::string& enum_name)
    {
        Checks::exit_with_message(VCPKG_LINE_INFO, "NULLVALUE of enum %s was used", enum_name);
    }
}
