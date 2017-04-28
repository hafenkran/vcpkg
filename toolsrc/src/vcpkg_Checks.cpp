#include "pch.h"

#include "vcpkg_Checks.h"
#include "vcpkg_System.h"
#include "vcpkglib.h"

namespace vcpkg::Checks
{
    [[noreturn]] void unreachable(const LineInfo& line_info)
    {
        System::println(System::Color::error, "Error: Unreachable code was reached");
        System::println(System::Color::error, line_info.to_string()); // Always print line_info here
#ifndef NDEBUG
        std::abort();
#else
        ::exit(EXIT_FAILURE);
#endif
    }

    [[noreturn]] void exit_with_code(const LineInfo& line_info, const int exit_code)
    {
        if (g_debugging)
        {
            System::println(System::Color::error, line_info.to_string());
        }

        ::exit(exit_code);
    }

    [[noreturn]] void exit_with_message(const LineInfo& line_info, const CStringView errorMessage)
    {
        System::println(System::Color::error, errorMessage);
        exit_fail(line_info);
    }

    void check_exit(const LineInfo& line_info, bool expression)
    {
        if (!expression)
        {
            exit_with_message(line_info, "");
        }
    }

    void check_exit(const LineInfo& line_info, bool expression, const CStringView errorMessage)
    {
        if (!expression)
        {
            exit_with_message(line_info, errorMessage);
        }
    }
}
