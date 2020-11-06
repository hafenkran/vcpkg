# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/compute
    REF boost-1.74.0
    SHA512 484fa370cc4dc98d40a6d0227d1313ff8097653390fde87928963b32bc30e43b0c81da542cc85bb17cfc6348e801d244fe177e6640f825b7899e5f0a6884ad46
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
