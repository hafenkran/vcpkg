# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/multiprecision
    REF boost-1.75.0
    SHA512 e937cf51cb41178ffe6edd7359cf63a55b36931cf835e6a7528dbaad0a09fa5b3fdc52bd07fe9f7552770b83e06050f6927d176622033f806c84fd845f693d59
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
