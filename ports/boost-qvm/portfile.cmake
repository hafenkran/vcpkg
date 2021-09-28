# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/qvm
    REF boost-1.77.0
    SHA512 23cc5a83a056270ec46e2e4a405da9319d08c551cec6011ecb0af67ce21bc6e0f2d992e2257c96de7bf5256910d527ad365afc3d2d9dfe16513ddfd4456eadf9
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
