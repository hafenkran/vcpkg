# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/accumulators
    REF boost-1.74.0
    SHA512 7e3dc91e7c5915f310b7b309a993d425b6bbba98b1c3c45f6c582f2756d44e7f913f5f14d6e14f68c367609b51791f958b3c8008e43b9ed133d941ed8649196e
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
