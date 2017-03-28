#include "pch.h"
#include "vcpkg_Commands.h"
#include "vcpkg_System.h"
#include "vcpkg_Files.h"
#include "Paragraphs.h"
#include "BinaryParagraph.h"

namespace vcpkg::Commands::Cache
{
    static std::vector<BinaryParagraph> read_all_binary_paragraphs(const vcpkg_paths& paths)
    {
        std::vector<BinaryParagraph> output;
        for (auto it = fs::directory_iterator(paths.packages); it != fs::directory_iterator(); ++it)
        {
            const fs::path& path = it->path();
            const expected<std::unordered_map<std::string, std::string>> pghs = Paragraphs::get_single_paragraph(path / "CONTROL");
            if (auto p = pghs.get())
            {
                const BinaryParagraph binary_paragraph = BinaryParagraph(*p);
                output.push_back(binary_paragraph);
            }
        }

        return output;
    }

    void perform_and_exit(const vcpkg_cmd_arguments& args, const vcpkg_paths& paths)
    {
        static const std::string example = Strings::format(
            "The argument should be a substring to search for, or no argument to display all cached libraries.\n%s", Commands::Help::create_example_string("cache png"));
        args.check_max_arg_count(1, example);
        args.check_and_get_optional_command_arguments({});

        const std::vector<BinaryParagraph> binary_paragraphs = read_all_binary_paragraphs(paths);
        if (binary_paragraphs.empty())
        {
            System::println("No packages are cached.");
            Checks::exit_success(VCPKG_LINE_INFO);
        }

        if (args.command_arguments.size() == 0)
        {
            for (const BinaryParagraph& binary_paragraph : binary_paragraphs)
            {
                const std::string displayname = binary_paragraph.displayname();
                System::println(displayname);
            }
        }
        else
        {
            // At this point there is 1 argument
            for (const BinaryParagraph& binary_paragraph : binary_paragraphs)
            {
                const std::string displayname = binary_paragraph.displayname();
                if (Strings::case_insensitive_ascii_find(displayname, args.command_arguments[0]) == displayname.end())
                {
                    continue;
                }

                System::println(displayname);
            }
        }

        Checks::exit_success(VCPKG_LINE_INFO);
    }
}
