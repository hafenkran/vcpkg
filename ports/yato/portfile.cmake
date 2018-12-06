include(vcpkg_common_functions)

vcpkg_from_bitbucket(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO alexey_gruzdev/yato
    REF v1.0
    SHA512 631b870fd2704a03d9d66ef244f4e50968ae63da4fda0c7cd1f6ce2cea2b1e8b4506b0148cd1af1e133a70fd5d9cdc9d8c054edac6141118ee3c9427e186b270
    HEAD_REF master
)

# Copy all header files
file(COPY "${SOURCE_PATH}/include/yato"
     DESTINATION "${CURRENT_PACKAGES_DIR}/include"
)
file(COPY "${SOURCE_PATH}/modules/actors/yato"
     DESTINATION "${CURRENT_PACKAGES_DIR}/include"
)
file(COPY "${SOURCE_PATH}/modules/config/yato"
     DESTINATION "${CURRENT_PACKAGES_DIR}/include"
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DYATO_BUILD_TESTS:BOOL=OFF
        -DYATO_BUILD_ACTORS:BOOL=ON
        -DYATO_BUILD_CONFIG:BOOL=ON
        -DYATO_CONFIG_MANUAL:BOOL=ON
        -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG:PATH=${CURRENT_PACKAGES_DIR}/debug/lib/
        -DCMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG:PATH=${CURRENT_PACKAGES_DIR}/debug/lib/
        -DCMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG:PATH=${CURRENT_PACKAGES_DIR}/debug/lib/
        -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE:PATH=${CURRENT_PACKAGES_DIR}/lib/
        -DCMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE:PATH=${CURRENT_PACKAGES_DIR}/lib/
        -DCMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE:PATH=${CURRENT_PACKAGES_DIR}/lib/
)

vcpkg_build_cmake()

# Handle copyright
file(COPY ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/yato)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/yato/LICENSE.txt ${CURRENT_PACKAGES_DIR}/share/yato/copyright)
