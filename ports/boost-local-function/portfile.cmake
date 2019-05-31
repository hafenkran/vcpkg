# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/local_function
    REF boost-1.70.0
    SHA512 7debd9d083fedd8446e98565bcc2fcab5091ba931166030143abef2351918f8a46a83a004b28e5ab4b413101052036424ec82d7b99428bc0e07660722e2c50c4
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
