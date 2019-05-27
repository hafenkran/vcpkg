# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/functional
    REF boost-1.70.0
    SHA512 ca32f1e0292835ff059e907e2392b059cdb85e1c1b7b7850f9e490d59ecd4d95d7cc2f6ebd548a167018b179812045104692e638334d35243da26117f8ccceb7
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
