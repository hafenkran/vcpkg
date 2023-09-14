vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ashvardanian/SimSIMD
    REF "v${VERSION}"
    SHA512 44a3f971bebbb4f4575dc50dc50795762fd5555f4811fc86a8699fe97dff556b4391128abb4f21b3b94210f9f6f20da854d9471d5443f4ad700a9e21ea905041
    HEAD_REF main
)

file(INSTALL "${SOURCE_PATH}/include" DESTINATION "${CURRENT_PACKAGES_DIR}")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
