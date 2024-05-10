# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/fiber
    REF boost-${VERSION}
    SHA512 57d580f142dfea6e2974870ae74e0d2617210081837316e8e5a21bb78fe7b6e08b75a89144c3ea48d2162b850e02eebb016b2ad23b151e25b2706812af32f573
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
