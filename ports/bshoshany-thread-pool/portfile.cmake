vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO bshoshany/thread-pool
    REF v3.2.0
    SHA512 785d6c4827e39b0128501ff4379ba0ffbf90ef4b612eccd0279027e6fc9ce9d2a463c2b8b93515ca0a1dc86dc4c34d9849bc281940b1f490086d1db49d5521bb
    HEAD_REF master
)

file(GLOB HEADER_FILES LIST_DIRECTORIES false "${SOURCE_PATH}/*.hpp")

file(INSTALL "${HEADER_FILES}" DESTINATION "${CURRENT_PACKAGES_DIR}/include")

file(INSTALL "${SOURCE_PATH}/LICENSE.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
