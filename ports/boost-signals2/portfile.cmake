# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/signals2
    REF boost-1.77.0
    SHA512 7391cff74532df1df43c107070bba15324d3511066ec6eb5062775f3bc1ca6be0846e1719dc638a9920e09ca7f2c943909434e8d36758d6535e192d7e5a4c298
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
