# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/outcome
    REF boost-1.72.0
    SHA512 3de487dfcdb07cbf3184cf7a75c4ce476ea905ee24bfb967dff30ec8b1b29e57f1d52858ec9ef3ed4f865696a2ce768aedea406bdf4e6147c631138ffa5d3858
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
