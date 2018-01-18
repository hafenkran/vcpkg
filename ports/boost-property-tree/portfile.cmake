# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/property_tree
    REF boost-1.66.0
    SHA512 257f3ae750d71c82c0585766e1a35ac90dfced98fdccde8fe5fc504f26e42e7c6629c83fa6cae098271f7cf0cbe669f00246248b548740b303e32c63e79b0492
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
