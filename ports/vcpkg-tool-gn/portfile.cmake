set(VCPKG_POLICY_EMPTY_PACKAGE enabled)

set(program GN)
set(search_names gn gn.exe)
set(paths_to_search "${CURRENT_PACKAGES_DIR}/tools/gn")

set(cipd_download_gn "https://chrome-infra-packages.appspot.com/dl/gn/gn")
if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
    EXEC_PROGRAM(uname ARGS -m OUTPUT_VARIABLE HOST_ARCH)
    if(HOST_ARCH STREQUAL "aarch64")
        set(program_version "GkfFAfAUyE-qfeWkdUMaeM1Ov64Fk3SjSj9pwKqZX7gC")
        set(gn_platform "linux-arm64")
        set(download_sha512 "E88201309A12C00CE60137261B8E1A759780C81D1925B819583B16D2095A16A7D32EFB2AF36C1E1D6EAA142BF6A6A811847D3140E4E94967EE28F4ADF6373E4B")
    else()
        set(program_version "Fv1ENXodhXmEXy_xpZr2gQkVJh57w_IsbsrEJOU0_EoC")
        set(gn_platform "linux-amd64")
        set(download_sha512 "A7A5CD5633C5547EC1B1A95958486DDAAC91F1A65881EDC0AD8F74DF44E82F08BA74358E9A72DFCDDE6F534A6B9C9A430D3E16ACE2E4346C4D2E9113F7654B3F")
    endif()
elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Darwin")
    set(supported_on_unix ON)
    EXEC_PROGRAM(uname ARGS -m OUTPUT_VARIABLE HOST_ARCH)
    if(HOST_ARCH STREQUAL "arm64")
        set(program_version "qMPtGq7xZlpb-lHjP-SK27ftT4X71WIvguuyx6X14DEC")
        set(gn_platform "mac-arm64")
        set(download_sha512 "D096FB958D017807427911089AB5A7655AED117F6851C0491AC8063CEDB544423122EF64DF4264ECA86C20A2BDE9E64D7B72DA7ED8C95C2BA79A68B8247D36B8")
    else()
        set(program_version "0x2juPLNfP9603GIyZrUfflxK6LiMcppLAoxEpYuIYoC")
        set(gn_platform "mac-amd64")
        set(download_sha512 "2696ECE7B2C8008CABDDF10024017E2ECF875F8679424E77052252BDDC83A2096DF3C61D89CD25120EF27E0458C8914BEEED9D418593BDBC4F6ED33A8D4C3DC5")
    endif()
else()
    if($ENV{PROCESSOR_ARCHITECTURE} STREQUAL "ARM64")
        set(program_version "q5ExVHmXyD34Q_Tzb-aRxsPipO-e37-csVRhVM7IJh0C")
        set(gn_platform "windows-amd64")
        set(download_sha512 "FA764AA44EB6F48ED50E855B4DC1DD1ABE35E45FD4AAC7F059A35293A14894C1B591215E34FB0CE9362E646EA9463BA3B489EFB7EBBAA2693D14238B50E4E686")
    else() # AMD64
        set(program_version "q5ExVHmXyD34Q_Tzb-aRxsPipO-e37-csVRhVM7IJh0C")
        set(gn_platform "windows-amd64")
        set(download_sha512 "FA764AA44EB6F48ED50E855B4DC1DD1ABE35E45FD4AAC7F059A35293A14894C1B591215E34FB0CE9362E646EA9463BA3B489EFB7EBBAA2693D14238B50E4E686")
    endif()
endif()

set(download_urls "${cipd_download_gn}/${gn_platform}/+/${program_version}")
set(download_filename "gn-${gn_platform}.zip")
vcpkg_download_distfile(archive_path
    URLS ${download_urls}
    SHA512 "${download_sha512}"
    FILENAME "${download_filename}"
)
file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools/gn")
vcpkg_execute_in_download_mode(
    COMMAND "${CMAKE_COMMAND}" -E tar xzf "${archive_path}"
    WORKING_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools/gn"
)

z_vcpkg_find_acquire_program_find_internal("${program}"
    PATHS ${paths_to_search}
    NAMES ${search_names}
)

message(STATUS "Using gn: ${GN}")
file(WRITE "${CURRENT_PACKAGES_DIR}/share/gn/version.txt" "${program_version}") # For vcpkg_find_acquire_program
