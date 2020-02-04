# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/icl
    REF boost-1.72.0
    SHA512 dd5666d04a3c849a5f59eccba767e2b733673a39851b67cab0e6cfb708be5f6fc1fdda6f9e1d29def1ca267533586ed0fdc2ece47048fb601556edfa1357131b
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
