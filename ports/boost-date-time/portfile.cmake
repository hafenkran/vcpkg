# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular.cmake)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/date_time
    REF boost-1.66.0
    SHA512 5c8ddf94d1c5a0bc5c216c9cbb4560a2e0aa7b116966a9a9250a517fb4c83f2fb9ad0c37c65f65e8cad2c7f21f621d696e1efd6d2bd557c1bfaa8b9d8c566f7d
    HEAD_REF master
)

boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
