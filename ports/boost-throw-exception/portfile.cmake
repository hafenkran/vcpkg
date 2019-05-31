# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/throw_exception
    REF boost-1.70.0
    SHA512 2b95ab70b141ea077c420c2fd6e139851aac6e6ccfb8a6772e7492066d3746f492f268a56ea79b2843e2631444d0a8dceba4551d98a3e315ef86017b307585fc
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
