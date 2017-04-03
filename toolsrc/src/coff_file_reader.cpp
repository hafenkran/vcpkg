#include "pch.h"
#include "coff_file_reader.h"
#include "vcpkg_Checks.h"

using namespace std;

namespace vcpkg::COFFFileReader
{
    template <class T>
    static T reinterpret_bytes(const char* data)
    {
        return (*reinterpret_cast<const T *>(&data[0]));
    }

    template <class T>
    static T read_value_from_stream(fstream& fs)
    {
        T data;
        fs.read(reinterpret_cast<char*>(&data), sizeof data);
        return data;
    }

    template <class T>
    static T peek_value_from_stream(fstream& fs)
    {
        fpos_t original_pos = fs.tellg().seekpos();
        T data;
        fs.read(reinterpret_cast<char*>(&data), sizeof data);
        fs.seekg(original_pos);
        return data;
    }

    static void verify_equal_strings(const LineInfo& line_info, const char* expected, const char* actual, int size, const char* label)
    {
        Checks::check_exit(line_info, memcmp(expected, actual, size) == 0, "Incorrect string (%s) found. Expected: (%s) but found (%s)", label, expected, actual);
    }

    static void read_and_verify_PE_signature(fstream& fs)
    {
        static const size_t OFFSET_TO_PE_SIGNATURE_OFFSET = 0x3c;

        static const char* PE_SIGNATURE = "PE\0\0";
        static const size_t PE_SIGNATURE_SIZE = 4;

        fs.seekg(OFFSET_TO_PE_SIGNATURE_OFFSET, ios_base::beg);
        const int32_t offset_to_PE_signature = read_value_from_stream<int32_t>(fs);

        fs.seekg(offset_to_PE_signature);
        char signature[PE_SIGNATURE_SIZE];
        fs.read(signature, PE_SIGNATURE_SIZE);
        verify_equal_strings(VCPKG_LINE_INFO, PE_SIGNATURE, signature, PE_SIGNATURE_SIZE, "PE_SIGNATURE");
        fs.seekg(offset_to_PE_signature + PE_SIGNATURE_SIZE, ios_base::beg);
    }

    static fpos_t align_to_size(const uint64_t unaligned, const uint64_t alignment_size)
    {
        fpos_t aligned = unaligned - 1;
        aligned /= alignment_size;
        aligned += 1;
        aligned *= alignment_size;
        return aligned;
    }

    struct coff_file_header
    {
        static const size_t HEADER_SIZE = 20;

        static coff_file_header read(fstream& fs)
        {
            coff_file_header ret;
            ret.data.resize(HEADER_SIZE);
            fs.read(&ret.data[0], HEADER_SIZE);
            return ret;
        }

        MachineType machineType() const
        {
            static const size_t MACHINE_TYPE_OFFSET = 0;
            static const size_t MACHINE_TYPE_SIZE = 2;

            std::string machine_field_as_string = data.substr(MACHINE_TYPE_OFFSET, MACHINE_TYPE_SIZE);
            const uint16_t machine = reinterpret_bytes<uint16_t>(machine_field_as_string.c_str());
            return getMachineType(machine);
        }

    private:
        std::string data;
    };

    struct archive_member_header
    {
        static const size_t HEADER_SIZE = 60;

        static archive_member_header read(fstream& fs)
        {
            static const size_t HEADER_END_OFFSET = 58;
            static const char* HEADER_END = "`\n";
            static const size_t HEADER_END_SIZE = 2;

            archive_member_header ret;
            ret.data.resize(HEADER_SIZE);
            fs.read(&ret.data[0], HEADER_SIZE);

            if (ret.data[0] != '\0') // Due to freeglut. github issue #223
            {
                const std::string header_end = ret.data.substr(HEADER_END_OFFSET, HEADER_END_SIZE);
                verify_equal_strings(VCPKG_LINE_INFO, HEADER_END, header_end.c_str(), HEADER_END_SIZE, "LIB HEADER_END");
            }

            return ret;
        }

        std::string name() const
        {
            static const size_t HEADER_NAME_OFFSET = 0;
            static const size_t HEADER_NAME_SIZE = 16;
            return data.substr(HEADER_NAME_OFFSET, HEADER_NAME_SIZE);
        }

        uint64_t member_size() const
        {
            static const size_t ALIGNMENT_SIZE = 2;

            static const size_t HEADER_SIZE_OFFSET = 48;
            static const size_t HEADER_SIZE_FIELD_SIZE = 10;
            const std::string as_string = data.substr(HEADER_SIZE_OFFSET, HEADER_SIZE_FIELD_SIZE);
            // This is in ASCII decimal representation
            const uint64_t value = std::strtoull(as_string.c_str(), nullptr, 10);

            const uint64_t aligned = align_to_size(value, ALIGNMENT_SIZE);
            return aligned;
        }

        std::string data;
    };

    struct offsets_array
    {
        static offsets_array read(fstream& fs, const uint32_t offset_count)
        {
            static const size_t OFFSET_WIDTH = 4;

            std::string raw_offsets;
            const size_t raw_offset_size = offset_count * OFFSET_WIDTH;
            raw_offsets.resize(raw_offset_size);
            fs.read(&raw_offsets[0], raw_offset_size);

            offsets_array ret;
            for (uint32_t i = 0; i < offset_count; ++i)
            {
                const std::string value_as_string = raw_offsets.substr(OFFSET_WIDTH * i, OFFSET_WIDTH * (i + 1));
                const uint32_t value = reinterpret_bytes<uint32_t>(value_as_string.c_str());

                // Ignore offsets that point to offset 0. See vcpkg github #223 #288 #292
                if (value != 0)
                {
                    ret.data.push_back(value);
                }
            }

            // Sort the offsets, because it is possible for them to be unsorted. See vcpkg github #292
            std::sort(ret.data.begin(), ret.data.end());
            return ret;
        }

        std::vector<uint32_t> data;
    };

    struct import_header
    {
        static const size_t HEADER_SIZE = 20;

        static import_header read(fstream& fs)
        {
            static const size_t SIG1_OFFSET = 0;
            static const uint16_t SIG1 = static_cast<uint16_t>(MachineType::UNKNOWN);
            static const size_t SIG1_SIZE = 2;

            static const size_t SIG2_OFFSET = 2;
            static const uint16_t SIG2 = 0xFFFF;
            static const size_t SIG2_SIZE = 2;

            import_header ret;
            ret.data.resize(HEADER_SIZE);
            fs.read(&ret.data[0], HEADER_SIZE);

            const std::string sig1_as_string = ret.data.substr(SIG1_OFFSET, SIG1_SIZE);
            const uint16_t sig1 = reinterpret_bytes<uint16_t>(sig1_as_string.c_str());
            Checks::check_exit(VCPKG_LINE_INFO, sig1 == SIG1, "Sig1 was incorrect. Expected %s but got %s", SIG1, sig1);

            const std::string sig2_as_string = ret.data.substr(SIG2_OFFSET, SIG2_SIZE);
            const uint16_t sig2 = reinterpret_bytes<uint16_t>(sig2_as_string.c_str());
            Checks::check_exit(VCPKG_LINE_INFO, sig2 == SIG2, "Sig2 was incorrect. Expected %s but got %s", SIG2, sig2);

            return ret;
        }

        MachineType machineType() const
        {
            static const size_t MACHINE_TYPE_OFFSET = 6;
            static const size_t MACHINE_TYPE_SIZE = 2;

            std::string machine_field_as_string = data.substr(MACHINE_TYPE_OFFSET, MACHINE_TYPE_SIZE);
            const uint16_t machine = reinterpret_bytes<uint16_t>(machine_field_as_string.c_str());
            return getMachineType(machine);
        }

    private:
        std::string data;
    };

    static void read_and_verify_archive_file_signature(fstream& fs)
    {
        static const char* FILE_START = "!<arch>\n";
        static const size_t FILE_START_SIZE = 8;

        fs.seekg(fs.beg);

        char file_start[FILE_START_SIZE];
        fs.read(file_start, FILE_START_SIZE);
        verify_equal_strings(VCPKG_LINE_INFO, FILE_START, file_start, FILE_START_SIZE, "LIB FILE_START");
    }

    DllInfo read_dll(const fs::path& path)
    {
        std::fstream fs(path, std::ios::in | std::ios::binary | std::ios::ate);
        Checks::check_exit(VCPKG_LINE_INFO, fs.is_open(), "Could not open file %s for reading", path.generic_string());

        read_and_verify_PE_signature(fs);
        coff_file_header header = coff_file_header::read(fs);
        MachineType machine = header.machineType();
        return {machine};
    }

    struct marker_t
    {
        void set_to_offset(const fpos_t position)
        {
            this->m_absolute_position = position;
        }

        void set_to_current_pos(fstream& fs)
        {
            this->m_absolute_position = fs.tellg().seekpos();
        }

        void seek_to_marker(fstream& fs) const
        {
            fs.seekg(this->m_absolute_position, ios_base::beg);
        }

        void advance_by(const uint64_t offset)
        {
            this->m_absolute_position += offset;
        }

    private:
        fpos_t m_absolute_position = 0;
    };

    LibInfo read_lib(const fs::path& path)
    {
        std::fstream fs(path, std::ios::in | std::ios::binary | std::ios::ate);
        Checks::check_exit(VCPKG_LINE_INFO, fs.is_open(), "Could not open file %s for reading", path.generic_string());

        read_and_verify_archive_file_signature(fs);

        marker_t marker;
        marker.set_to_current_pos(fs);

        // First Linker Member
        const archive_member_header first_linker_member_header = archive_member_header::read(fs);
        Checks::check_exit(VCPKG_LINE_INFO, first_linker_member_header.name().substr(0, 2) == "/ ", "Could not find proper first linker member");
        marker.advance_by(archive_member_header::HEADER_SIZE + first_linker_member_header.member_size());
        marker.seek_to_marker(fs);

        const archive_member_header second_linker_member_header = archive_member_header::read(fs);
        Checks::check_exit(VCPKG_LINE_INFO, second_linker_member_header.name().substr(0, 2) == "/ ", "Could not find proper second linker member");
        // The first 4 bytes contains the number of archive members
        const uint32_t archive_member_count = read_value_from_stream<uint32_t>(fs);
        const offsets_array offsets = offsets_array::read(fs, archive_member_count);
        marker.advance_by(archive_member_header::HEADER_SIZE + second_linker_member_header.member_size());
        marker.seek_to_marker(fs);

        bool hasLongnameMemberHeader = peek_value_from_stream<uint16_t>(fs) == 0x2F2F;
        if (hasLongnameMemberHeader)
        {
            const archive_member_header longnames_member_header = archive_member_header::read(fs);
            marker.advance_by(archive_member_header::HEADER_SIZE + longnames_member_header.member_size());
            marker.seek_to_marker(fs);
        }

        std::set<MachineType> machine_types;
        // Next we have the obj and pseudo-object files
        for (const uint32_t offset : offsets.data)
        {
            marker.set_to_offset(offset + archive_member_header::HEADER_SIZE); // Skip the header, no need to read it.
            marker.seek_to_marker(fs);
            const uint16_t first_two_bytes = peek_value_from_stream<uint16_t>(fs);
            const bool isImportHeader = getMachineType(first_two_bytes) == MachineType::UNKNOWN;
            const MachineType machine = isImportHeader ? import_header::read(fs).machineType() : coff_file_header::read(fs).machineType();
            machine_types.insert(machine);
        }

        return {std::vector<MachineType>(machine_types.cbegin(), machine_types.cend())};
    }
}
