# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/optional
    REF boost-1.78.0
    SHA512 490eadd8017595a5c019da8c0c3b0e2569829d58ab31b2b575a2bbf9f218b9fc7aa42dcec3f6e9178ca10c438966889bbd77bb6013bf749bde9ba49e7fba2d97
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
