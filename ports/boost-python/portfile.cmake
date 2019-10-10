# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/python
    REF boost-1.71.0
    SHA512 0b78db2d0fda09298092cfbe7580d67db015aac7d5fac44c363dcc025f61d043fe4a87446b3f8f1fa76ae685838a98b0ed68609ecd945328f5fc4b12a493ee6a
    HEAD_REF master
)

# Find Python. Can't use find_package here, but we already know where everything is
file(GLOB PYTHON_INCLUDE_PATH "${CURRENT_INSTALLED_DIR}/include/python[0-9.]*")
set(PYTHONLIBS_RELEASE "${CURRENT_INSTALLED_DIR}/lib")
set(PYTHONLIBS_DEBUG "${CURRENT_INSTALLED_DIR}/debug/lib")
string(REGEX REPLACE ".*python([0-9\.]+)$" "\\1" PYTHON_VERSION "${PYTHON_INCLUDE_PATH}")
include(${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
