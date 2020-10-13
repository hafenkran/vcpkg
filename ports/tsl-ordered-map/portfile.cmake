include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Tessil/ordered-map
    REF 4051af7e344e0c0c6af5573b064342c0987d1028 # v1.0.0
    SHA512 c4789df12db34bba1a1b2e07ada39afd6bfb637d34006675ee7f83253e49b5741d301cebb7c368c7a99311c51304f844a6229d00df3717e346e5fc1254e7721b
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug)

file(INSTALL ${SOURCE_PATH}/LICENSE 
     DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} 
     RENAME copyright
)
