#include "pch.h"

#include <vcpkg/base/checks.h>
#include <vcpkg/base/strings.h>
#include <vcpkg/base/util.h>

namespace vcpkg::Strings::details
{
    // To disambiguate between two overloads
    static const auto isspace = [](const char c) { return std::isspace(c); };

    // Avoids C4244 warnings because of char<->int conversion that occur when using std::tolower()
    static char tolower_char(const char c) { return static_cast<char>(std::tolower(c)); }

#if defined(_WIN32)
    static _locale_t& c_locale()
    {
        static _locale_t c_locale_impl = _create_locale(LC_ALL, "C");
        return c_locale_impl;
    }
#endif

    std::string format_internal(const char* fmtstr, ...)
    {
        va_list args;
        va_start(args, fmtstr);

#if defined(_WIN32)
        const int sz = _vscprintf_l(fmtstr, c_locale(), args);
#else
        const int sz = vsnprintf(nullptr, 0, fmtstr, args);
#endif
        Checks::check_exit(VCPKG_LINE_INFO, sz > 0);

        std::string output(sz, '\0');

#if defined(_WIN32)
        _vsnprintf_s_l(&output.at(0), output.size() + 1, output.size(), fmtstr, c_locale(), args);
#else
        va_start(args, fmtstr);
        auto res = vsnprintf(&output.at(0), output.size() + 1, fmtstr, args);
#endif
        va_end(args);

        return output;
    }
}

namespace vcpkg::Strings
{
    std::wstring to_utf16(const CStringView& s)
    {
#if defined(_WIN32)
        const int size = MultiByteToWideChar(CP_UTF8, 0, s.c_str(), -1, nullptr, 0);
        std::wstring output;
        output.resize(size - 1);
        MultiByteToWideChar(CP_UTF8, 0, s.c_str(), -1, output.data(), size - 1);
        return output;
#else
        Checks::unreachable(VCPKG_LINE_INFO);
#endif
    }

    std::string to_utf8(const CWStringView& w)
    {
#if defined(_WIN32)
        const int size = WideCharToMultiByte(CP_UTF8, 0, w.c_str(), -1, nullptr, 0, nullptr, nullptr);
        std::string output;
        output.resize(size - 1);
        WideCharToMultiByte(CP_UTF8, 0, w.c_str(), -1, output.data(), size - 1, nullptr, nullptr);
        return output;
#else
        Checks::unreachable(VCPKG_LINE_INFO);
#endif
    }

    std::string::const_iterator case_insensitive_ascii_find(const std::string& s, const std::string& pattern)
    {
        const std::string pattern_as_lower_case(ascii_to_lowercase(pattern));
        return search(s.begin(),
                      s.end(),
                      pattern_as_lower_case.begin(),
                      pattern_as_lower_case.end(),
                      [](const char a, const char b) { return details::tolower_char(a) == b; });
    }

    bool case_insensitive_ascii_contains(const std::string& s, const std::string& pattern)
    {
        return case_insensitive_ascii_find(s, pattern) != s.end();
    }

    bool case_insensitive_ascii_equals(const CStringView left, const CStringView right)
    {
#if defined(_WIN32)
        return _stricmp(left.c_str(), right.c_str()) == 0;
#else
        return strcasecmp(left.c_str(), right.c_str()) == 0;
#endif
    }

    std::string ascii_to_lowercase(const std::string& input)
    {
        std::string output(input);
        std::transform(output.begin(), output.end(), output.begin(), &details::tolower_char);
        return output;
    }

    bool case_insensitive_ascii_starts_with(const std::string& s, const std::string& pattern)
    {
#if defined(_WIN32)
        return _strnicmp(s.c_str(), pattern.c_str(), pattern.size()) == 0;
#else
        return strncasecmp(s.c_str(), pattern.c_str(), pattern.size()) == 0;
#endif
    }

    void trim(std::string* s)
    {
        s->erase(std::find_if_not(s->rbegin(), s->rend(), details::isspace).base(), s->end());
        s->erase(s->begin(), std::find_if_not(s->begin(), s->end(), details::isspace));
    }

    std::string trimmed(const std::string& s)
    {
        auto whitespace_back = std::find_if_not(s.rbegin(), s.rend(), details::isspace).base();
        auto whitespace_front = std::find_if_not(s.begin(), whitespace_back, details::isspace);
        return std::string(whitespace_front, whitespace_back);
    }

    void trim_all_and_remove_whitespace_strings(std::vector<std::string>* strings)
    {
        for (std::string& s : *strings)
        {
            trim(&s);
        }

        Util::erase_remove_if(*strings, [](const std::string& s) { return s.empty(); });
    }

    std::vector<std::string> split(const std::string& s, const std::string& delimiter)
    {
        std::vector<std::string> output;

        if (delimiter.empty())
        {
            output.push_back(s);
            return output;
        }

        const size_t delimiter_length = delimiter.length();
        size_t i = 0;
        for (size_t pos = s.find(delimiter); pos != std::string::npos; pos = s.find(delimiter, pos))
        {
            output.push_back(s.substr(i, pos - i));
            pos += delimiter_length;
            i = pos;
        }

        // Add the rest of the string after the last delimiter, unless there is nothing after it
        if (i != s.length())
        {
            output.push_back(s.substr(i, s.length()));
        }

        return output;
    }
}
