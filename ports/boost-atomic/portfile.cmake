# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/atomic
    REF boost-${VERSION}
    SHA512 1d1a484a070d25724f084287e321a56a191373bf5387158a0e055d870056d0ad04d37596008c19a52469d823a7c4721fb682fc1870e583effa5061cea6571097
    HEAD_REF master
    PATCHES
        fix-include.patch
        
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
