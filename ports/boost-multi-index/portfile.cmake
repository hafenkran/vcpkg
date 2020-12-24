# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/multi_index
    REF boost-1.75.0
    SHA512 162ee2d46ee899cf15f27e12248dbb02b34d22f38f63afb90abc8ac24aabd2ca58864acc56af0eded999baebac36452ca502e59fc985ce2146df24d5f9e43f01
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
