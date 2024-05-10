# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/wave
    REF boost-${VERSION}
    SHA512 edc04ac361f7c582b9486e33438d3d6615dad3d355cbd58b1a73050fb9a74fbf415fb0a256b6bd9559981891cb063ad9f406f598736c74096a81d44adebf28cc
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
