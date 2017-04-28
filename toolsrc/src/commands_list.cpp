#include "pch.h"

#include "vcpkg_Commands.h"
#include "vcpkg_System.h"
#include "vcpkglib.h"
#include "vcpkglib_helpers.h"

namespace vcpkg::Commands::List
{
    static void do_print(const StatusParagraph& pgh)
    {
        System::println("%-27s %-16s %s",
                        pgh.package.displayname(),
                        pgh.package.version,
                        details::shorten_description(pgh.package.description));
    }

    void perform_and_exit(const VcpkgCmdArguments& args, const VcpkgPaths& paths)
    {
        static const std::string example = Strings::format(
            "The argument should be a substring to search for, or no argument to display all installed libraries.\n%s",
            Commands::Help::create_example_string("list png"));
        args.check_max_arg_count(1, example);
        args.check_and_get_optional_command_arguments({});

        const StatusParagraphs status_paragraphs = database_load_check(paths);
        std::vector<StatusParagraph*> installed_packages = get_installed_ports(status_paragraphs);

        if (installed_packages.empty())
        {
            System::println("No packages are installed. Did you mean `search`?");
            Checks::exit_success(VCPKG_LINE_INFO);
        }

        std::sort(installed_packages.begin(),
                  installed_packages.end(),
                  [](const StatusParagraph* lhs, const StatusParagraph* rhs) -> bool {
                      return lhs->package.displayname() < rhs->package.displayname();
                  });

        if (args.command_arguments.size() == 0)
        {
            for (const StatusParagraph* status_paragraph : installed_packages)
            {
                do_print(*status_paragraph);
            }
        }
        else
        {
            // At this point there is 1 argument
            for (const StatusParagraph* status_paragraph : installed_packages)
            {
                const std::string displayname = status_paragraph->package.displayname();
                if (Strings::case_insensitive_ascii_find(displayname, args.command_arguments[0]) == displayname.end())
                {
                    continue;
                }

                do_print(*status_paragraph);
            }
        }

        Checks::exit_success(VCPKG_LINE_INFO);
    }
}
