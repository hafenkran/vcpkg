# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/property_map
    REF boost-1.73.0
    SHA512 e79ec94f850ebfcbb85c29536d552299c8d81e328b22a2690dbef1665ac2b4c2e2c33cf2577fd0800a04fc94fbf4b9b8aeafb3646736abf7739373d0760d4e91
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
