# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/type_index
    REF boost-1.74.0
    SHA512 81e47c9b9d070ab987b988d8d572f1d80178adca6a22e6d1a435b412a098dc0d5f8a406c4e816ef1e36e62c467980fd0e1bceee9170e6058a5ec763deae591cd
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
