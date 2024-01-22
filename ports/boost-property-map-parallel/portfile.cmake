# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/property_map_parallel
    REF boost-${VERSION}
    SHA512 2a151616e81042627fb85a7dafd866059ab938baefa64d0f1ff9c05f55d72db93319dafdf100d71a521137969ee7729b96d09d1a8843c875ab21fa5811c53caf
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
