# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/preprocessor
    REF boost-1.67.0
    SHA512 9bb18c25144c1428c6e9a32a670c041bc6165b862636b5c626e8b66959906988605f75548fc61539f91c32282b72c150b8b398f7fcee2fa2e5720032b74fd80f
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
