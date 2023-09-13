# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/poly_collection
    REF boost-1.83.0
    SHA512 03f5d17f5a77f9d05ad6a57f04e7987e5efd560e770025d5618c26c7078bd55630f463df51d6e150b45f415357ea6a79d6402a9922d1a986d2521e9d4ce8fe52
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
