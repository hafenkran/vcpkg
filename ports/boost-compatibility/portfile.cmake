# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/compatibility
    REF boost-1.68.0
    SHA512 73124528957098af9480e776419d3a5ed86ec954695c020075e16730de5bbfd8f104e9463bdbc8996423d89ab5a775dc76b5b9127a44a2f53e4691324776bf17
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
