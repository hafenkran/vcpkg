# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/proto
    REF boost-1.77.0
    SHA512 2c50272ffbf1e0c69cec467238f77b4617ed7099a197a45c51232587f38e063b5397d3ab00ecd66dcb23ff0ab2ad22885d56569bc11093613de4e31b7f8d6a5a
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
