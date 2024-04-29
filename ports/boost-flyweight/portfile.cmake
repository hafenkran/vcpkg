# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/flyweight
    REF boost-${VERSION}
    SHA512 7dcbb4d29c01524f1d1a097614c5f31ca40b720c974f2587cdcc6cf3c5538c36fbf691fa07475f1de3847baf8e9a0ee8883f83d75af171a760450626d621c9e3
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
