# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/xpressive
    REF boost-1.69.0
    SHA512 ac6ab9955ab4cb6e8a1905304595a9b33c71b4041673b6e942adc023bd67c7b64bf786976f40cb2daea6ce164f72fff50fc6fa583dd12d5978a4e3ba6524b523
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
