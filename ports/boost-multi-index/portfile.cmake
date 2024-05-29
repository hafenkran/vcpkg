# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/multi_index
    REF boost-${VERSION}
    SHA512 ea1cc2bab0ae24474ad4d4db5976653ce47df6d50917e2965bacd2b0a3025c25c19b393d781ff0f3d720f959375f8d13d77fabfaa717203ace8e9686827341ff
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
