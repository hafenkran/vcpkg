# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/foreach
    REF boost-${VERSION}
    SHA512 f14cc78d31dd71ecbbf357c2f280f480acc3171efafc25bd75ed43ad5398a7274eab15bd5b566aac4a2aece66a6a0d4d9557ea26850d9f8c796b8a2e9b57fce6
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
