# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/mpl
    REF boost-1.73.0
    SHA512 1d3a131d589e8c2bea4637c5bb3d42beee60289201ee946435a797b4953cae6338b739b8c0abb0d8b1fb1ffacbdc6c609139424090e433a4f5aa98f6158a5c8d
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
