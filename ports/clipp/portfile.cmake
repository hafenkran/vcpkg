vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO "muellan/clipp"
    REF 2c32b2f1f7cc530b1ec1f62c92f698643bb368db
    SHA512 4645fafe85a8099ea97b85e939747a12e9b3b92213b5b8207a9c277537377b77b5daebd88a4c090ea89cfff2937a9fc155da6e8b5558574d7129227c28826e1c
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/clipp RENAME copyright)
