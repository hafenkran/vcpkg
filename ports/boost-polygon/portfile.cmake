# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/polygon
    REF boost-1.69.0
    SHA512 4cd1a3a9856322f475cdf3d4643043143531cf78b9f951d7b533bbfcab38df1dfa55d2326a983dcb7c88635efe72f878215280532dcf47c6cee755bcdfe50f2f
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
