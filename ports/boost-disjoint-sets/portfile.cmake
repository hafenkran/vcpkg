# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/disjoint_sets
    REF boost-1.69.0
    SHA512 2d43ec3020249c232b35ce6ab6be541e4dbdddc4dbe9f0e2f92796e3200670df03c40651c0d7fe3f91f89b2524b0f023a4152e80d8b3ee7738ea5fa6880801e3
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
