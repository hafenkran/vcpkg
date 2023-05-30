vcpkg_from_github(OUT_SOURCE_PATH SOURCE_PATH
    REPO "SRombauts/SQLiteCpp"
    REF ${VERSION}
    HEAD_REF master
    SHA512 9702b17c55b1b3bc46a72d5c204b560249e9c1f02647c864fd4ca54011e4b0238638800ee870baa5106512a9568338d3faa9c9f9799d42fbd558d10376e3b73a
    PATCHES
        fix_dependency.patch
        add_runtime_destination.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        sqlcipher SQLITE_HAS_CODEC
)

set(USE_STACK_PROTECTION "")
if(VCPKG_TARGET_IS_MINGW)
    set(USE_STACK_PROTECTION "-DSQLITECPP_USE_STACK_PROTECTION=OFF")
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DSQLITECPP_RUN_CPPLINT=OFF
        -DSQLITECPP_RUN_CPPCHECK=OFF
        -DSQLITECPP_INTERNAL_SQLITE=OFF
        -DSQLITE_ENABLE_COLUMN_METADATA=ON
        -DSQLITECPP_USE_STATIC_RUNTIME=OFF # unconditionally off because vcpkg's toolchains already do the right thing
        # See https://github.com/SRombauts/SQLiteCpp/blob/e74403264ec7093060f4ed0e84bc9208997c8344/CMakeLists.txt#L40-L46
        ${USE_STACK_PROTECTION}
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/SQLiteCpp)
vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
