# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/assert
    REF boost-1.81.0
    SHA512 c443b61a9ad29d4c9707aaaa997300a959fdef2d360aec9ee221abc12cd8446b3bc969e6c282ba778bee7d6fb54cc02655f15e01eacf1ad87262534dc4cc32bf
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
