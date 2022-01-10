# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/callable_traits
    REF boost-1.78.0
    SHA512 7bdd11a059bbf81e648e44750d77d1089674f34b167d86bfcfc653d2b6a6841188bccac2e7e9769a76022e052bba5b6d4c0b72bec1f630196a5ea290ffe5ee24
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
