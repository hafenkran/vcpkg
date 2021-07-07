# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/interprocess
    REF boost-1.76.0
    SHA512 853cb0d6a51d42223d2c242d03b339f723e18c54c7a1f4e2be841a85a816ebc1524f5b9b90441c054072d5a408a724ee8dbeac22997ef5dfb3cf78c87c2acf71
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
