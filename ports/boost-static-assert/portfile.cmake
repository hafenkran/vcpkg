# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/static_assert
    REF boost-1.78.0
    SHA512 213098d7fae87af6ee0919de1e3e5110f96eb6238ff200e9080d18e355ea3403b24b8eab318bde1dab8c32d7ee780ded46e39056e625bf5f6bcca9b48fdfee7d
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
