#include "pch.h"

#include <vcpkg/base/checks.h>
#include <vcpkg/base/strings.h>
#include <vcpkg/base/system.h>
#include <vcpkg/base/util.h>
#include <vcpkg/commands.h>
#include <vcpkg/help.h>

#if defined(_WIN32)
#include <bcrypt.h>

#ifndef NT_SUCCESS
#define NT_SUCCESS(Status) (((NTSTATUS)(Status)) >= 0)
#endif

namespace vcpkg::Commands::Hash
{
    namespace
    {
        std::string to_hex(const unsigned char* string, const size_t bytes)
        {
            static constexpr char HEX_MAP[] = "0123456789abcdef";

            std::string output;
            output.resize(2 * bytes);

            size_t current_char = 0;
            for (size_t i = 0; i < bytes; i++)
            {
                // high
                output[current_char] = HEX_MAP[(string[i] & 0xF0) >> 4];
                ++current_char;
                // low
                output[current_char] = HEX_MAP[(string[i] & 0x0F)];
                ++current_char;
            }

            return output;
        }

        struct BCryptAlgorithmHandle : Util::ResourceBase
        {
            BCRYPT_ALG_HANDLE handle = nullptr;

            ~BCryptAlgorithmHandle()
            {
                if (handle) BCryptCloseAlgorithmProvider(handle, 0);
            }
        };

        struct BCryptHashHandle : Util::ResourceBase
        {
            BCRYPT_HASH_HANDLE handle = nullptr;

            ~BCryptHashHandle()
            {
                if (handle) BCryptDestroyHash(handle);
            }
        };

        struct BCryptHasher
        {
            explicit BCryptHasher(const std::string& hash_type)
            {
                NTSTATUS error_code =
                    BCryptOpenAlgorithmProvider(&this->algorithm_handle.handle,
                                                Strings::to_utf16(Strings::ascii_to_uppercase(hash_type)).c_str(),
                                                nullptr,
                                                0);
                Checks::check_exit(VCPKG_LINE_INFO, NT_SUCCESS(error_code), "Failed to open the algorithm provider");

                DWORD hash_buffer_bytes;
                DWORD cb_data;
                error_code = BCryptGetProperty(this->algorithm_handle.handle,
                                               BCRYPT_HASH_LENGTH,
                                               reinterpret_cast<PUCHAR>(&hash_buffer_bytes),
                                               sizeof(DWORD),
                                               &cb_data,
                                               0);
                Checks::check_exit(VCPKG_LINE_INFO, NT_SUCCESS(error_code), "Failed to get hash length");
                this->length_in_bytes = hash_buffer_bytes;
            }

            std::string hash_file(const fs::path& path) const
            {
                BCryptHashHandle hash_handle;
                this->initialize_hash_handle(hash_handle);

                FILE* file = nullptr;
                const auto ec = _wfopen_s(&file, path.c_str(), L"rb");
                Checks::check_exit(VCPKG_LINE_INFO, ec == 0, "Failed to open file: %s", path.u8string());
                unsigned char buffer[4096];
                while (const auto actual_size = fread(buffer, 1, sizeof(buffer), file))
                {
                    hash_data(hash_handle, buffer, actual_size);
                }
                fclose(file);

                return this->finalize_hash_handle(hash_handle);
            }

            std::string hash_string(const std::string& s) const
            {
                BCryptHashHandle hash_handle;
                this->initialize_hash_handle(hash_handle);
                hash_data(hash_handle, reinterpret_cast<unsigned char*>(const_cast<char*>(s.c_str())), s.size());
                return this->finalize_hash_handle(hash_handle);
            }

        private:
            void initialize_hash_handle(BCryptHashHandle& hash_handle) const
            {
                const NTSTATUS error_code =
                    BCryptCreateHash(this->algorithm_handle.handle, &hash_handle.handle, nullptr, 0, nullptr, 0, 0);
                Checks::check_exit(VCPKG_LINE_INFO, NT_SUCCESS(error_code), "Failed to initialize the hasher");
            }

            void hash_data(BCryptHashHandle& hash_handle, unsigned char* buffer, const size_t& data_size) const
            {
                const NTSTATUS error_code =
                    BCryptHashData(hash_handle.handle, buffer, static_cast<ULONG>(data_size), 0);
                Checks::check_exit(VCPKG_LINE_INFO, NT_SUCCESS(error_code), "Failed to hash data");
            }

            std::string finalize_hash_handle(const BCryptHashHandle& hash_handle) const
            {
                std::unique_ptr<unsigned char[]> hash_buffer = std::make_unique<UCHAR[]>(this->length_in_bytes);
                const NTSTATUS error_code =
                    BCryptFinishHash(hash_handle.handle, hash_buffer.get(), this->length_in_bytes, 0);
                Checks::check_exit(VCPKG_LINE_INFO, NT_SUCCESS(error_code), "Failed to finalize the hash");
                return to_hex(hash_buffer.get(), this->length_in_bytes);
            }

            BCryptAlgorithmHandle algorithm_handle;
            ULONG length_in_bytes;
        };
    }

    std::string get_file_hash(const fs::path& path, const std::string& hash_type)
    {
        return BCryptHasher{hash_type}.hash_file(path);
    }

    std::string get_string_hash(const std::string& s, const std::string& hash_type)
    {
        return BCryptHasher{hash_type}.hash_string(s);
    }
}

#else
namespace vcpkg::Commands::Hash
{
    std::string get_file_hash(const fs::path& path, const std::string& hash_type)
    {
        if (!Strings::case_insensitive_ascii_starts_with(hash_type, "SHA"))
        {
            Checks::exit_with_message(
                VCPKG_LINE_INFO, "shasum only supports SHA hashes, but %s was provided", hash_type);
        }

        const std::string digest_size = hash_type.substr(3, hash_type.length() - 3);

        const std::string cmd_line = Strings::format(
            R"(shasum -a %s "%s" | awk '{ print $1 }')", digest_size, path.u8string());
        const auto ec_data = System::cmd_execute_and_capture_output(cmd_line);
        Checks::check_exit(VCPKG_LINE_INFO,
                           ec_data.exit_code == 0,
                           "Failed to run:\n"
                           "    %s",
                           cmd_line);
        return Strings::trim(std::string{ec_data.output});
    }

    std::string get_string_hash(const std::string& s, const std::string& hash_type)
    {
        if (!Strings::case_insensitive_ascii_starts_with(hash_type, "SHA"))
        {
            Checks::exit_with_message(
                VCPKG_LINE_INFO, "shasum only supports SHA hashes, but %s was provided", hash_type);
        }

        const std::string digest_size = hash_type.substr(3, hash_type.length() - 3);

        const std::string cmd_line = Strings::format(
            R"(echo -n "%s" | shasum -a %s | awk '{ print $1 }')", s, digest_size);
        const auto ec_data = System::cmd_execute_and_capture_output(cmd_line);
        Checks::check_exit(VCPKG_LINE_INFO,
                           ec_data.exit_code == 0,
                           "Failed to run:\n"
                           "    %s",
                           cmd_line);
        return Strings::trim(std::string{ec_data.output});
    }
}
#endif

namespace vcpkg::Commands::Hash
{
    const CommandStructure COMMAND_STRUCTURE = {
        Strings::format("The argument should be a file path\n%s",
                        Help::create_example_string("hash boost_1_62_0.tar.bz2")),
        1,
        2,
        {},
        nullptr,
    };

    void perform_and_exit(const VcpkgCmdArguments& args)
    {
        Util::unused(args.parse_arguments(COMMAND_STRUCTURE));

        const fs::path file_to_hash = args.command_arguments[0];
        const std::string algorithm = args.command_arguments.size() == 2 ? args.command_arguments[1] : "SHA512";
        const std::string hash = get_file_hash(file_to_hash, algorithm);
        System::println(hash);
        Checks::exit_success(VCPKG_LINE_INFO);
    }
}
