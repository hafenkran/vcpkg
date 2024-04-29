# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/coroutine2
    REF boost-${VERSION}
    SHA512 f2077b1eeabe6cd7315301ccc74b74dc2583ea7b0d791d6dbe47f3aa5e4761249f0b2d5461a100ede73478d38cbe7238181d73e45ea32eb2ef98357104441526
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
