vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO pubby/flat
    REF 7ddca21388ad45d5b830d836b256d47d1289315f
    SHA512 eecb9683c681e46e166140c491536f87ec78c6ed456ad0295f2b53631c377c6356fea6bb8a2d17ca27457807a03f9e188bf27b3ff489d78624ab997957279cf3
    HEAD_REF master
)

file(INSTALL ${SOURCE_PATH}/
    DESTINATION ${CURRENT_PACKAGES_DIR}/include/flat
    FILES_MATCHING PATTERN "*.hpp")

file(INSTALL ${SOURCE_PATH}/LICENSE_1_0.txt
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/flat
    RENAME copyright)
