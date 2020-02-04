# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/exception
    REF boost-1.72.0
    SHA512 506ee9bec68a169b60e438bf29ed673aa8be2f745ab64dc8381a6ad1b9ca7e674a1b3009a828893c7451fd34de302fdb41d75018e1986a64543fe27ea5c7903b
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})

set(VCPKG_LIBRARY_LINKAGE static)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
