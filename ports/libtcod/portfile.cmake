vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libtcod/libtcod
    REF 1.23.0
    SHA512 efb9d1bca56268bb467ea11f640ed3807f269cd6c6cd7ea3296b3e1fb26bbe688cd8a21d3c5bb070d747a5321088e5fe4fe2a9cc52c145958a9db120d9abf878
    HEAD_REF main
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    INVERTED_FEATURES
        "png" CMAKE_DISABLE_FIND_PACKAGE_lodepng-c
        "sdl" CMAKE_DISABLE_FIND_PACKAGE_SDL2
        "sdl" CMAKE_DISABLE_FIND_PACKAGE_GLAD
        "threads" CMAKE_DISABLE_FIND_PACKAGE_Threads
        "unicode" CMAKE_DISABLE_FIND_PACKAGE_utf8proc
        "unicode" CMAKE_DISABLE_FIND_PACKAGE_unofficial-utf8proc
        "zlib" CMAKE_DISABLE_FIND_PACKAGE_ZLIB
)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        ${FEATURE_OPTIONS}
        -DCMAKE_INSTALL_INCLUDEDIR=${CURRENT_PACKAGES_DIR}/include
        -DLIBTCOD_SDL2=find_package
        -DLIBTCOD_ZLIB=find_package
        -DLIBTCOD_GLAD=find_package
        -DLIBTCOD_LODEPNG=find_package
        -DLIBTCOD_UTF8PROC=vcpkg
        -DLIBTCOD_STB=find_package
)

vcpkg_cmake_install()

vcpkg_copy_pdbs()

vcpkg_cmake_config_fixup()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
