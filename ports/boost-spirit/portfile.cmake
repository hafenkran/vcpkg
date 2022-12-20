# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/spirit
    REF boost-1.81.0
    SHA512 3249f109b7aa151a434f9de8a32418cd7f9d7e670980dc15033a359a61b9ebf5010f817557a0952fc7ecc248e0cbbc2155bd86178dd42a47b48d8b0263e087ee
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
