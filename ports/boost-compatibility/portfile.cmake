# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/compatibility
    REF boost-1.73.0
    SHA512 ce2b5f908c878cc34694b024c1f4609098bf1e8801df90e067bcf535e267632142639653230588e92819c8b579c59d0703bb8d9ec06ec8a4fc3d103634673724
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
