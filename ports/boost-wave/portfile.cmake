# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/wave
    REF boost-${VERSION}
    SHA512 4514128df8fde022183db34d211271673c84dffa249dddbe9d05634e0d2cb5c28cb007341d329fb94bbed65ae4c7ec0146f8dfa8c1bc436a8b695f0edc82ad55
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
