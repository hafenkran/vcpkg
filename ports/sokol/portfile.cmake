# header-only library

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO floooh/sokol
    REF 425e906d2af8c976c30f7e925a303fea9f0bf879
    SHA512 4606735b9466637f3b676402cc2d7ef96e4152836c901d7a84039c52951aec27922726de21a537e0fef2d2218f48e3a9a3c32c3bc67076c10d199f067f50dad9
    HEAD_REF master
)

file(GLOB SOKOL_INCLUDE_FILES ${SOURCE_PATH}/*.h)
file(COPY ${SOKOL_INCLUDE_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/include)

file(GLOB SOKOL_UTIL_INCLUDE_FILES ${SOURCE_PATH}/util/*.h)
file(COPY ${SOKOL_UTIL_INCLUDE_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/include/util)

# Handle copyright
configure_file(${SOURCE_PATH}/LICENSE ${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright COPYONLY)
