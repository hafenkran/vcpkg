# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/logic
    REF boost-1.80.0
    SHA512 17c9a38212bc851bef2ab43db1c7027b51d4726bcb8225bdcdc52a84872b3e40e0f37722b9b10840116f200135dd80d850085caf9b70b8fbf2ae2fc99882cbde
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
