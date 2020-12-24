# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/locale
    REF boost-1.75.0
    SHA512 13bc48ef4ae0805abd5eecde90406486a00c350187343ae2cc7da9b7e94d15be952312c1c07c4faf4d62e13401c6e450c3c3d06649af01a690fc7200a20744ed
    HEAD_REF master
    PATCHES
        0001-Fix-boost-ICU-support.patch
        allow-force-finding-iconv.patch
)

include(${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
configure_file(
    "${CMAKE_CURRENT_LIST_DIR}/b2-options.cmake.in"
    "${CURRENT_BUILDTREES_DIR}/vcpkg-b2-options.cmake"
    @ONLY
)
boost_modular_build(
    SOURCE_PATH ${SOURCE_PATH}
    BOOST_CMAKE_FRAGMENT "${CURRENT_BUILDTREES_DIR}/vcpkg-b2-options.cmake"
)
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
