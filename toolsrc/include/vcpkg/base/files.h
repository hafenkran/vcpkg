#pragma once

#include <vcpkg/base/expected.h>

#if defined(_WIN32)
#include <filesystem>
#else
#include <experimental/filesystem>
#endif

namespace fs
{
    namespace stdfs = std::experimental::filesystem;

    using stdfs::copy_options;
    using stdfs::file_status;
    using stdfs::file_type;
    using stdfs::path;
    using stdfs::u8path;

    inline bool is_regular_file(file_status s) { return stdfs::is_regular_file(s); }
    inline bool is_directory(file_status s) { return stdfs::is_directory(s); }
    inline bool status_known(file_status s) { return stdfs::status_known(s); }
}

namespace vcpkg::Files
{
    struct Filesystem
    {
        virtual Expected<std::string> read_contents(const fs::path& file_path) const = 0;
        virtual Expected<std::vector<std::string>> read_lines(const fs::path& file_path) const = 0;
        virtual fs::path find_file_recursively_up(const fs::path& starting_dir, const std::string& filename) const = 0;
        virtual std::vector<fs::path> get_files_recursive(const fs::path& dir) const = 0;
        virtual std::vector<fs::path> get_files_non_recursive(const fs::path& dir) const = 0;

        virtual void write_lines(const fs::path& file_path, const std::vector<std::string>& lines) = 0;
        virtual void write_contents(const fs::path& file_path, const std::string& data, std::error_code& ec) = 0;
        virtual void rename(const fs::path& oldpath, const fs::path& newpath) = 0;
        virtual void rename(const fs::path& oldpath, const fs::path& newpath, std::error_code& ec) = 0;
        virtual bool remove(const fs::path& path) = 0;
        virtual bool remove(const fs::path& path, std::error_code& ec) = 0;
        virtual std::uintmax_t remove_all(const fs::path& path, std::error_code& ec) = 0;
        virtual bool exists(const fs::path& path) const = 0;
        virtual bool is_directory(const fs::path& path) const = 0;
        virtual bool is_regular_file(const fs::path& path) const = 0;
        virtual bool is_empty(const fs::path& path) const = 0;
        virtual bool create_directory(const fs::path& path, std::error_code& ec) = 0;
        virtual bool create_directories(const fs::path& path, std::error_code& ec) = 0;
        virtual void copy(const fs::path& oldpath, const fs::path& newpath, fs::copy_options opts) = 0;
        virtual bool copy_file(const fs::path& oldpath,
                               const fs::path& newpath,
                               fs::copy_options opts,
                               std::error_code& ec) = 0;
        virtual fs::file_status status(const fs::path& path, std::error_code& ec) const = 0;

        inline void write_contents(const fs::path& file_path, const std::string& data)
        {
            std::error_code ec;
            write_contents(file_path, data, ec);
            Checks::check_exit(
                VCPKG_LINE_INFO, !ec, "error while writing file: %s: %s", file_path.u8string(), ec.message());
        }
    };

    Filesystem& get_real_filesystem();

    static const char* FILESYSTEM_INVALID_CHARACTERS = R"(\/:*?"<>|)";

    bool has_invalid_chars_for_filesystem(const std::string& s);

    void print_paths(const std::vector<fs::path>& paths);

    std::vector<fs::path> find_from_PATH(const std::string& name);
}
