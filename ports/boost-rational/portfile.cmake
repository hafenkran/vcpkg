# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/rational
    REF boost-1.72.0
    SHA512 971c52ccc78e21f7fcbc87e7eb5f4097dfe855aebb09c940aae5997dc7b420a652166374980d8218ad9daa8e81ffb81102968ea0281e80b5a65ae9d86c1087db
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
