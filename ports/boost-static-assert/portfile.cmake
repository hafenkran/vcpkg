# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/static_assert
    REF boost-1.68.0
    SHA512 af109c668d083a9d7dc63b123b6621b919eab132589bad55a05c0fcdbb0939516a5a787512a87964a04362a4dd73af572293c3a3c2035d41401e78be34ca877e
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
