vcpkg_fail_port_install(ON_TARGET "UWP" ON_TARGET "x86" "arm" "aarch64")
vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO jandrewrogers/MetroHash
        REF v1.1.3
        SHA512 02b6316e5ebf3d81465eea8a068565452be642394ddf5a53350affbbc9b9bfe1c3d182f7e8f7d49895351c48e11929e465777535e4354e01b6d0ba459e583ac5
        HEAD_REF master
)
if(VCPKG_TARGET_IS_ANDROID)
    vcpkg_replace_string(${SOURCE_PATH}/src/metrohash.h
        "#include \"metrohash128crc.h\""
        "//#include \"metrohash128crc.h\" // It can't be supported for Android")
endif()
configure_file(${CURRENT_PORT_DIR}/CMakeLists.txt ${SOURCE_PATH}/CMakeLists.txt COPYONLY)
configure_file(${CURRENT_PORT_DIR}/Config.cmake.in ${SOURCE_PATH}/cmake/Config.cmake.in COPYONLY)

vcpkg_configure_cmake(
        SOURCE_PATH ${SOURCE_PATH}
        PREFER_NINJA
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/${PORT})
vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
