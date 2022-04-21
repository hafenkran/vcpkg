# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/convert
    REF boost-1.79.0
    SHA512 deb3b28c8c356f4d36c9f5af01f682572c14f10b3466acb34619aa56ee398b687a95a731cd144e870b3c6581540b7ae48a1cfe4b6926a9781470aac6e07da9c4
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
