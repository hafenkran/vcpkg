include(vcpkg_common_functions)
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REF 3.0.5-rc3
    REPO "aquynh/capstone"
    SHA512 1327fc570fc2310f71c4d7329528c05e30b9ad68ea50254b9a8c4b3b113f5165c2e0474ec99bbe1e6e46f2820379f388e4c2082c156027e117d88a8f1908acfe
    HEAD_REF master
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" CAPSTONE_BUILD_STATIC)
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" CAPSTONE_BUILD_SHARED)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DCAPSTONE_BUILD_STATIC=${CAPSTONE_BUILD_STATIC}
        -DCAPSTONE_BUILD_SHARED=${CAPSTONE_BUILD_SHARED}

        #-DCAPSTONE_ARCHS="x86"
        -DCAPSTONE_X86_SUPPORT=ON
        -DCAPSTONE_ARM_SUPPORT=ON
        -DCAPSTONE_ARM64_SUPPORT=ON
        -DCAPSTONE_MIPS_SUPPORT=OFF
        -DCAPSTONE_PPC_SUPPORT=OFF
        -DCAPSTONE_SPARC_SUPPORT=OFF
        -DCAPSTONE_SYSZ_SUPPORT=OFF
        -DCAPSTONE_XCORE_SUPPORT=OFF

        -DCAPSTONE_BUILD_TESTS=OFF
    OPTIONS_RELEASE
        -DCAPSTONE_BUILD_DIET=ON
        -DCAPSTONE_X86_REDUCE=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(GLOB EXES ${CURRENT_PACKAGES_DIR}/bin/*.exe ${CURRENT_PACKAGES_DIR}/debug/bin/*.exe)
if(EXES)
    file(REMOVE ${EXES})
endif()
if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE.TXT 
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/capstone 
    RENAME copyright)
