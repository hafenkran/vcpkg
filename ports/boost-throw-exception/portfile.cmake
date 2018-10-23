# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/throw_exception
    REF boost-1.68.0
    SHA512 7ec624763becab452f437eaa6e03c0882f672735a2bc4c1edfa92ccf2acd1c667905ccf15ae0f40091f64b425d83025c7ade4b55bd7418e542b12d575a1c8f60
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
