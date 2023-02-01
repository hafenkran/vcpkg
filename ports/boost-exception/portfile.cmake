# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/exception
    REF boost-1.81.0
    SHA512 54bb812a259bca5568dcbabdfb0d5bb0fdb3332a24837023822ba1eb30cd466d29251791b7401d56adeda5bd7b4f1507080b82e4f23f5f1f52ee1d46c9ce8d6f
    HEAD_REF master
)

include(${CURRENT_HOST_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
