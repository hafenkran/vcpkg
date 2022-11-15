vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO BOINC/boinc
    REF client_release/7.20/7.20.4
    SHA512 6103027d6a4f2c0dfce0860aa73238a5c21504f2d185dd607bdf39a09394a4550b3111452659b453fdb9fee82000a97b33bc51656b5f45533ccd455ff49b01c7
    HEAD_REF master
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

if(VCPKG_TARGET_IS_LINUX OR VCPKG_TARGET_IS_ANDROID)
    vcpkg_configure_make(
        SOURCE_PATH ${SOURCE_PATH}
        AUTOCONFIG
        NO_ADDITIONAL_PATHS
        OPTIONS
            ${OPTIONS}
            --disable-server
            --disable-client
            --disable-manager
    )

    if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
        file(COPY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/config.h DESTINATION ${SOURCE_PATH}/config-h-Release)
    endif()
    if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
        file(COPY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/config.h DESTINATION ${SOURCE_PATH}/config-h-Debug)
    endif()
endif()

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup()

vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${SOURCE_PATH}/COPYING.LESSER" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
file(INSTALL "${SOURCE_PATH}/COPYRIGHT" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME license)
