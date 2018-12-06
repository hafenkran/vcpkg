# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/iterator
    REF boost-1.68.0
    SHA512 e8e223bc5b9334618d676e2aefdeffdde6f31097b634d2ca1fa3d6e73976c42dd123ed76081e13d1f023a7d39f49cc53d63b28e541c2aae858cbf569818bd14e
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
