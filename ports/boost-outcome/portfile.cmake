# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/outcome
    REF boost-1.81.0
    SHA512 0e79e5ca56a600d90d8d56ccc3631a7615119c4d9e6d6280d513ef0c96105c79e28d6dbd1f2b1deee4e702eb4393c404d9fba3144869c345650724185625da39
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
