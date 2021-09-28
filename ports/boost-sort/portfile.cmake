# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/sort
    REF boost-1.77.0
    SHA512 b27b58ea45a0392b8d2151e2d39899383f3c5d2a487de67433c64d89d529eaa8d7ca07559b944f0b93986e70f1de8d366d2d726e0a425c973ad9d98e1f8946cd
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
