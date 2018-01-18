# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/polygon
    REF boost-1.66.0
    SHA512 7d8b3b275ab5c010a3c1736e59290b514d44080a7fec9e26b28d39c3df2346ac9f5d762b84c6f55296452bbcdf3a8cff5ac3f2895a99be90c4630efb04229157
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
