# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/sort
    REF boost-1.76.0
    SHA512 71fd8a9b5ccf29d5971bdb2b58288555a6a63c12b5463dcd0e11fc7132f0c620a77fde4492005204e8ef4a9084a9ecb29f6c9ad8e325227e491a99ba033f2080
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
