# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/function_types
    REF boost-1.66.0
    SHA512 ecac32195728a38bb83ee553d25567bca3a4075948fbffdf2f5d6cd7c4df7ca1b90ed32ec2811e6aa7eea264d6a1e63c8fc2fc9a091d081e231aadb513ed1646
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
