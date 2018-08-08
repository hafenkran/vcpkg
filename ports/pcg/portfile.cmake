include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO imneme/pcg-cpp
    REF v0.98.1
    SHA512 3625913eba3b5d3ff0763a00728535cd5273a335f0ce0a9ab8e0cd8183a52309cbf72ae50d089cfea89445201993466a5533469db1cb6e82b14c62564731fe70
    HEAD_REF master
)

file(INSTALL ${SOURCE_PATH}/include/pcg_extras.hpp DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(INSTALL ${SOURCE_PATH}/include/pcg_random.hpp DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(INSTALL ${SOURCE_PATH}/include/pcg_uint128.hpp DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/pcg RENAME copyright)
