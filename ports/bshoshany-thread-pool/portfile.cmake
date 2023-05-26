vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO bshoshany/thread-pool
    REF "v${VERSION}"
    SHA512 43200acf989adbabc0478d847931d2e46c4ce13de9d28f2e603e6b86d38a7370c0e50bacd36bff5a1a200f33ae6394764adc64ce9a54df5e418d85fb525b4b3f
    HEAD_REF master
)

file(GLOB HEADER_FILES LIST_DIRECTORIES false "${SOURCE_PATH}/include/*.hpp")

file(INSTALL ${HEADER_FILES} DESTINATION "${CURRENT_PACKAGES_DIR}/include")

file(INSTALL "${SOURCE_PATH}/LICENSE.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
