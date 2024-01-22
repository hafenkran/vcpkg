# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/concept_check
    REF boost-${VERSION}
    SHA512 1674f998aaf593fa3031a27c8cf49391811a662ecfaea1d111f812f6002fd5a60352c67d87aca2e271b09a4bbf17beab8951dd6bfeeee805c75592359a29f0b8
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
