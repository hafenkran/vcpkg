# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/type_index
    REF boost-1.67.0
    SHA512 31a471bedaa8e30eb84e22e7f059938ffb25c649a80b203067da1c63bcb8d1fcd9cf61bff593fcdb6d463408bc6cb2775dbb589ac04bc6de7e0bc351e0b3abd9
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
