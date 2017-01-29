include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/opus-1.1.4)
vcpkg_download_distfile(ARCHIVE
    URLS "http://downloads.xiph.org/releases/opus/opus-1.1.4.tar.gz"
    FILENAME "opus-1.1.4.tar.gz"
    SHA512 57f14b9e8037eaa02a4d86535d3bbcceca249310fbc9ef1a452cc19dd442d4cf338d5db241d20605c236e22549df2c8266b7486c5f1666b80c532afd52cb3585
)
vcpkg_extract_source_archive(${ARCHIVE})

if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    set(RELEASE_CONFIGURATION "Release")
    set(DEBUG_CONFIGURATION "Debug")
else()
    set(RELEASE_CONFIGURATION "ReleaseDll")
    set(DEBUG_CONFIGURATION "DebugDll")
endif()

if(TARGET_TRIPLET MATCHES "x86")
    set(ARCH_DIR "Win32")
elseif(TARGET_TRIPLET MATCHES "x64")
    set(ARCH_DIR "x64")
else()
    message("Architecture not supported")
endif()

function(build_project PROJECT_PATH)
    vcpkg_build_msbuild(
        PROJECT_PATH ${PROJECT_PATH}
        RELEASE_CONFIGURATION ${RELEASE_CONFIGURATION}
        DEBUG_CONFIGURATION ${DEBUG_CONFIGURATION}
    )
endfunction(build_project)


build_project(${SOURCE_PATH}/win32/VS2015/celt.vcxproj)
build_project(${SOURCE_PATH}/win32/VS2015/silk_common.vcxproj)
build_project(${SOURCE_PATH}/win32/VS2015/silk_float.vcxproj)
build_project(${SOURCE_PATH}/win32/VS2015/silk_fixed.vcxproj)
build_project(${SOURCE_PATH}/win32/VS2015/opus.vcxproj)


if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    # Install release build
    file(INSTALL ${SOURCE_PATH}/win32/VS2015/${ARCH_DIR}/${RELEASE_CONFIGURATION}/opus.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib/)
    file(INSTALL ${SOURCE_PATH}/win32/VS2015/${ARCH_DIR}/${RELEASE_CONFIGURATION}/celt.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib/)
    file(INSTALL ${SOURCE_PATH}/win32/VS2015/${ARCH_DIR}/${RELEASE_CONFIGURATION}/silk_common.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib/)
    file(INSTALL ${SOURCE_PATH}/win32/VS2015/${ARCH_DIR}/${RELEASE_CONFIGURATION}/silk_fixed.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib/)
    file(INSTALL ${SOURCE_PATH}/win32/VS2015/${ARCH_DIR}/${RELEASE_CONFIGURATION}/silk_float.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib/)

    # Install debug build
    file(INSTALL ${SOURCE_PATH}/win32/VS2015/${ARCH_DIR}/${DEBUG_CONFIGURATION}/opus.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib/)
    file(INSTALL ${SOURCE_PATH}/win32/VS2015/${ARCH_DIR}/${DEBUG_CONFIGURATION}/opus.pdb DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib/)
    file(INSTALL ${SOURCE_PATH}/win32/VS2015/${ARCH_DIR}/${DEBUG_CONFIGURATION}/celt.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib/)
    file(INSTALL ${SOURCE_PATH}/win32/VS2015/${ARCH_DIR}/${DEBUG_CONFIGURATION}/celt.pdb DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib/)
    file(INSTALL ${SOURCE_PATH}/win32/VS2015/${ARCH_DIR}/${DEBUG_CONFIGURATION}/silk_common.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib/)
    file(INSTALL ${SOURCE_PATH}/win32/VS2015/${ARCH_DIR}/${DEBUG_CONFIGURATION}/silk_common.pdb DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib/)
    file(INSTALL ${SOURCE_PATH}/win32/VS2015/${ARCH_DIR}/${DEBUG_CONFIGURATION}/silk_fixed.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib/)
    file(INSTALL ${SOURCE_PATH}/win32/VS2015/${ARCH_DIR}/${DEBUG_CONFIGURATION}/silk_fixed.pdb DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib/)
    file(INSTALL ${SOURCE_PATH}/win32/VS2015/${ARCH_DIR}/${DEBUG_CONFIGURATION}/silk_float.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib/)
    file(INSTALL ${SOURCE_PATH}/win32/VS2015/${ARCH_DIR}/${DEBUG_CONFIGURATION}/silk_float.pdb DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib/)
else()
    # Install release build
    file(INSTALL ${SOURCE_PATH}/win32/VS2015/${ARCH_DIR}/${RELEASE_CONFIGURATION}/opus.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib/)
    file(INSTALL ${SOURCE_PATH}/win32/VS2015/${ARCH_DIR}/${RELEASE_CONFIGURATION}/opus.dll DESTINATION ${CURRENT_PACKAGES_DIR}/bin/)

    # Install debug build
    file(INSTALL ${SOURCE_PATH}/win32/VS2015/${ARCH_DIR}/${DEBUG_CONFIGURATION}/opus.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib/)
    file(INSTALL ${SOURCE_PATH}/win32/VS2015/${ARCH_DIR}/${DEBUG_CONFIGURATION}/opus.dll DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin/)
    file(INSTALL ${SOURCE_PATH}/win32/VS2015/${ARCH_DIR}/${DEBUG_CONFIGURATION}/opus.pdb DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin/)
endif()

# Install headers
file(INSTALL ${SOURCE_PATH}/include DESTINATION ${CURRENT_PACKAGES_DIR}/include RENAME opus)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/opus RENAME copyright)
