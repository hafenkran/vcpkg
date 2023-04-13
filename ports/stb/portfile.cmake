vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO nothings/stb
    REF 5736b15f7ea0ffb08dd38af21067c314d6a3aae9 # committed on 2023-04-11
    SHA512 55bc75284cf8a092c527d1ae18c461c9d0ab6aacdcf3b873abde54c06d9b8a0ae249ce47c7ad25809e075bfbb58e9c879d43e1df2708083860c07ac3bbb30d60
    HEAD_REF master
)

file(GLOB HEADER_FILES "${SOURCE_PATH}/*.h" "${SOURCE_PATH}/stb_vorbis.c")
file(COPY ${HEADER_FILES} DESTINATION "${CURRENT_PACKAGES_DIR}/include")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/FindStb.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/vcpkg-cmake-wrapper.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
