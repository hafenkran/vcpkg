# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/heap
    REF boost-${VERSION}
    SHA512 7f6ca56d00a2a2f36176f5da0c2b73f809ce1edbaf7a0da819341cf141be45c40d457175115c1da5d06e6fa1c933b8085f6f3133cd168a69d9e40c2ff6fdf409
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
