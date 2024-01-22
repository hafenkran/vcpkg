# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/pfr
    REF boost-${VERSION}
    SHA512 e6fa00165cc3871bf33c92ac218c1b313725450651afa2372f34f23ebc4c71114b75735923852aabf3855bc415d332a21feb557c3198dba2d25d816fa1e25dfe
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
