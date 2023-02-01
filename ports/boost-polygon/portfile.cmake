# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/polygon
    REF boost-1.81.0
    SHA512 81b0a9b26e1c53eeac1122e5e17d4f30be39286051b3467076730ab987a20f3a0825b6a27375e27c9ccbb231dd410ed3f86695b6f9801299c891b4eeaefd8537
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
