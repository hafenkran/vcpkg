include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO opencv/ade
    REF v0.1.1f
    SHA512 fbdec8f3d5811a573abb81f1ceb6fb8d40274439013f749645db5430c6d9cdc52227c25203f1a68177b263d648bb65197ea7c2bea7871264a06585e59892631c
    HEAD_REF master
)

vcpkg_configure_cmake(
  SOURCE_PATH ${SOURCE_PATH}
  PREFER_NINJA
  OPTIONS_DEBUG
    -DCMAKE_DEBUG_POSTFIX=d
)

vcpkg_install_cmake()

file(COPY ${CURRENT_PACKAGES_DIR}/debug/share/ade/adeTargets-debug.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/ade/)

file(READ ${CURRENT_PACKAGES_DIR}/share/ade/adeTargets-debug.cmake ADE_TARGET_DEBUG)
string(REPLACE "/lib/"
               "/debug/lib/" ADE_TARGET_DEBUG "${ADE_TARGET_DEBUG}")
file(WRITE ${CURRENT_PACKAGES_DIR}/share/ade/adeTargets-debug.cmake "${ADE_TARGET_DEBUG}")

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/ade RENAME copyright)
