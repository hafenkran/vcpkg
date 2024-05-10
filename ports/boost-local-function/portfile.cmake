# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/local_function
    REF boost-${VERSION}
    SHA512 97f9bc06932b409925f239a5f20d04f53d4b80888a00361d24a59974ea8526110d8f6b1a38103cf9e816c71f1ca1ea34a0c6a3825bf19235dc16a1b85afd47ff
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
