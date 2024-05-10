# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/compat
    REF boost-${VERSION}
    SHA512 b295bdb52d6dc5e615da15bde21b5c349ea760fb307f8bbbc4dce3cd5b72c992de0f21ffc112c214f857266621f556bd5ede24f7cfc6226b04df4dce77ba3e75
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
