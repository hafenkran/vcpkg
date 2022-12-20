# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/mp11
    REF boost-1.81.0
    SHA512 656e8c13b49962fc24b1087346d3d604c93a3f4d06c4eb5bac137ba84e0b823857cce9c1c2ab059c3e2ed51620a030c306643331e41cc9abc095b0700c93cdba
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
