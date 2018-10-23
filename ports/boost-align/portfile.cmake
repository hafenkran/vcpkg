# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/align
    REF boost-1.68.0
    SHA512 70379431769ffbfd3e5a6f1d9580a0d70933925ba7cf6a862fbe0f257b4ccb66b86ece6af7d78c16835d836012811708f179da2956c0851388f4ce38ff056b5c
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
