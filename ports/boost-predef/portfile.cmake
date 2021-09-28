# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/predef
    REF boost-1.77.0
    SHA512 d3c6b0fc10200aa49d7b5db542e40a858f1697c457391fab777384a974718f2b855fc526f6f44fb329a74139b46e05cc17ce57db2e35fe0388c976ce80f1f964
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})

file(COPY ${SOURCE_PATH}/tools/check DESTINATION ${CURRENT_PACKAGES_DIR}/share/boost-predef)
