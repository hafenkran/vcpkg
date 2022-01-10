# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/move
    REF boost-1.78.0
    SHA512 e17ceeaf96375e2fed7ad8be88970cdcb9b94ff3e101bdf4291ef48bf64485da3c1b7449f77881a7a757a9f5a81568cb387733e1b1b3c66f99058db1487e7554
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
