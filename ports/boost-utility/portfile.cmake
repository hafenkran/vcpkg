# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/utility
    REF boost-1.72.0
    SHA512 4630263d13239d5ce548821038277138268dcbc82a161196147e91147efbab289f71679449a35eb242c540be22ad5595fc0cd88b4dafb2e9b9e651bf398ed8b6
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
