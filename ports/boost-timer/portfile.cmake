# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/timer
    REF boost-${VERSION}
    SHA512 9b0e462bc03c08f4b6c5761957e781a1af7f7a8a36e64d73c5ae71c569a7c8abfec91de89feda5ac1f4cfd15d322fc3fe08ca9b32bf2106a6bf37976dace25f8
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
