# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/functional
    REF boost-${VERSION}
    SHA512 dd38234ee1bb25828349378a1db7adce044a440e441afb7b6e3279b14283cf928350ee56fba5f8d3328c115477bc84b59f3d9e0fff02e975e5e6d2500ef649d9
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
