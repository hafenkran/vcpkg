# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/icl
    REF boost-1.78.0
    SHA512 83d4f74ef6c4dbe7e6e9eaf1665bc2e013fa4236a92ea5b702889cb67e86d2c141897a8a9b627ef693c6514ddd148ea9f2120fc606e255238dd7ebd083a5fc47
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
