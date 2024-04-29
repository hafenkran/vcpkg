# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/conversion
    REF boost-${VERSION}
    SHA512 f296e8dc604a9c99b72e786633da7d14e10363b4da64e276fc332176ff86dbfb9e212935139c674d373640b769177f99dd173ca3d1a9156428525c4a22fd0909
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
