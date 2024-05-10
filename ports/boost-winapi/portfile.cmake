# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/winapi
    REF boost-${VERSION}
    SHA512 77ef70a765c4f167fbacedff544db06410763f46db1f12f87bc0d24bf493c12e5062b2b9cafc1d969268922ab806d53c32d104bf6483c29fdc9e08d0a18109e3
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
