# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/url
    REF boost-1.82.0
    SHA512 b8d785b3e64fd8b4b9ae6162958ee9d67a6eb220823e50e91977e37b6954440d83302df2afae93119fc707428981f0c07b262e3ea68675ea6cbd47e3dd8c20c1
    HEAD_REF master
)

vcpkg_replace_string("${SOURCE_PATH}/Jamfile"
    "import ../../config/checks/config : requires ;"
    "import config/checks/config : requires ;"
)
file(COPY "${CURRENT_INSTALLED_DIR}/share/boost-config/checks" DESTINATION "${SOURCE_PATH}/config")
include(${CURRENT_HOST_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
