# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/ptr_container
    REF boost-1.80.0
    SHA512 ff8293ff63bb4bc02d9dd7237154c28a186bf968fd1f03866976ab5a245636db2b074922671a3ad1687858fb8d7ef86c251f9d39be0d5763df1c45ecb56e4c40
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
