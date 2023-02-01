# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/crc
    REF boost-1.81.0
    SHA512 6e3d4dbf6343d936a2884a2445482c7245dd03eae46395ba168e50fb551aedd538feb00102b83a13b6fdfbc58f87d09c8252dfd8e584d835f4a9886ecf26619b
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
