# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/parameter_python
    REF boost-${VERSION}
    SHA512 cfc948f558c389c55a1d44bf34bde03f3a6f59019af54e5d7fd5e0af5cd33231275bfbaa50402b428f8194c29e82f9c6f0b2ada3dc6450d74e577b0dd1f66328
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
