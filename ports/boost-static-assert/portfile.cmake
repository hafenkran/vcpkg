# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/static_assert
    REF boost-1.77.0
    SHA512 465b6af0f0eb66b0587f97dd1869d86c31dcdb9eb2d7d55249d4dc2d4c77eca0a501d1ccb82e0f93fc3be80ed2983b1b854a116ec965654eac43bdaaa9d4b2dc
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
