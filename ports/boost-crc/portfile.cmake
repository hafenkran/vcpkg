# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/crc
    REF boost-1.74.0
    SHA512 4ab6284ed92614f76a32693acba6d40440b8717279434e7db41403e027c20d0684f4ff4aaf6929f35b1a0f624269f42e0a61d2f6bac7e39df25539e72d4d2abe
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
