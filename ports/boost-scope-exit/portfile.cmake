# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/scope_exit
    REF boost-1.79.0
    SHA512 92b4fac0a73455baede0625f5b56c8015e86ec61f90722b5ddb6c94a52f8a329ffd979d51e287b5a916f0e003cecd2bf6d6f246306499b423d98d4f652acc7f6
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
