vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO gdabah/distorm
    REF 3.5.2b
    SHA512 8AAD0C51E8D9DFAEAA069A3D4FADE4BDF87CCE464C85898B6B4888FA51A9BB6EC1221FAF32ACF59EBD047CCEB9A535B2FF93D196FD14FA834D8ECE5685417A55
    HEAD_REF master
    PATCHES
        fix-arm-builds.patch
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}")

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS_DEBUG
        -DDISABLE_INSTALL_HEADERS=ON
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
