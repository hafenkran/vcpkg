include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO themoos/essential-moos
    REF b897ea86dba8b61412dc48ac0cfb5ff34cdaf5f6
    SHA512 7284744d211dcdcb0cd321eec96f3632ccda690e8894261f4f09a06bc8faefb2de68f4f2f755f4eeef5bb586044e98ac65cdd18c15193a1a4632bd2f4208c52f 
    HEAD_REF master
)

message(STATUS "MOOS Essential Source Path: ${SOURCE_PATH}")
message(STATUS "MOOS Essential CMAKE_CURRENT_LIST_DIR: ${CMAKE_CURRENT_LIST_DIR}")

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES ${CMAKE_CURRENT_LIST_DIR}/fix.patch
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_SHARED)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DBUILD_SHARED_LIBS=${BUILD_SHARED}
)

vcpkg_install_cmake()

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/MOOS)
if(EXISTS "${CURRENT_PACKAGES_DIR}/bin/pAntler")
    file(RENAME ${CURRENT_PACKAGES_DIR}/bin/pAntler ${CURRENT_PACKAGES_DIR}/tools/MOOS/pAntler)
    file(RENAME ${CURRENT_PACKAGES_DIR}/bin/pLogger ${CURRENT_PACKAGES_DIR}/tools/MOOS/pLoggers)
    file(RENAME ${CURRENT_PACKAGES_DIR}/bin/pMOOSBridge ${CURRENT_PACKAGES_DIR}/tools/MOOS/pMOOSBridge)
    file(RENAME ${CURRENT_PACKAGES_DIR}/bin/pScheduler ${CURRENT_PACKAGES_DIR}/tools/MOOS/pScheduler)
    file(RENAME ${CURRENT_PACKAGES_DIR}/bin/pShare ${CURRENT_PACKAGES_DIR}/tools/MOOS/pShare)
endif()


if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug)
endif()

file(WRITE ${CURRENT_PACKAGES_DIR}/include/fake_header.h "// fake header to pass vcpkg post install check \n")
file(WRITE ${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright "see moos-core for copyright\n" )
#
#
