# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/locale
    REF boost-1.80.0
    SHA512 b05bdef8bc0f1f1c1183ce97394e008d69ff316e934570dfb50fef49503d7c4dba8e3d742a701b70d8df21559a577b5f114714214ef8974ada36796c221a2d32
    HEAD_REF master
    PATCHES fix-dependencies.patch
)

include(${CURRENT_HOST_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
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
