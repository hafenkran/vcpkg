# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/nowide
    REF boost-${VERSION}
    SHA512 f1e10a0fe92869bc8b30a11286a90fd47b83756a239e2b434cddbe1ffc7a19fb77913b0fe21a35ebc0a93ac386c0ad8ee167213c93b1a82cca21d0cde1a1e4d7
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
