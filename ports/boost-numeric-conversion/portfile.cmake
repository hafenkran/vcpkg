# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/numeric_conversion
    REF boost-1.68.0
    SHA512 08fadfb49b2996b118684a90e450d8426ea20270ca2c0a677c61f88b033f3e77139559fa9507a1fa0dbd84621f44502f7bf2949166c8915411da2da543178c01
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
