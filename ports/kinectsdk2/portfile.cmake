# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

include(vcpkg_common_functions)

string(LENGTH "${CURRENT_BUILDTREES_DIR}" BUILDTREES_PATH_LENGTH)
if(BUILDTREES_PATH_LENGTH GREATER 37 AND CMAKE_HOST_WIN32)
    message(WARNING "Kinectsdk2's buildsystem uses very long paths and may fail on your system.\n"
        "We recommend moving vcpkg to a short path such as 'C:\\src\\vcpkg' or using the subst command."
    )
endif()

if(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm")
    message(FATAL_ERROR "This port does not currently support architecture: ${VCPKG_TARGET_ARCHITECTURE}")
endif()

set(KINECTSDK20_VERSION "v2.0_1409")
vcpkg_download_distfile(KINECTSDK20_INSTALLER
    URLS "https://download.microsoft.com/download/F/2/D/F2D1012E-3BC6-49C5-B8B3-5ACFF58AF7B8/KinectSDK-${KINECTSDK20_VERSION}-Setup.exe"
    FILENAME "KinectSDK-${KINECTSDK20_VERSION}-Setup.exe"
    SHA512 ae3b00f45282ab2ed6ea36c09e42e1b274074f41546ecfbe00facf1fffa2e5a762ffeffb9ba2194f716e8122e0fbd9a8ef63c62be68d2b50a40e4f8c5a821f5f
)

vcpkg_find_acquire_program(DARK)

set(KINECTSDK20_WIX_INSTALLER "${KINECTSDK20_INSTALLER}")
set(KINECTSDK20_WIX_EXTRACT_DIR "${CURRENT_BUILDTREES_DIR}/src/installer/wix")
vcpkg_execute_required_process(
    COMMAND ${DARK} -x ${KINECTSDK20_WIX_EXTRACT_DIR} ${KINECTSDK20_WIX_INSTALLER}
    WORKING_DIRECTORY ${CURRENT_BUILDTREES_DIR}
    LOGNAME extract_wix_installer
)

file(TO_NATIVE_PATH "${KINECTSDK20_WIX_EXTRACT_DIR}/AttachedContainer/KinectSDK-${KINECTSDK20_VERSION}-x64.msi" KINECTSDK20_MSI_INSTALLER)
file(TO_NATIVE_PATH "${CURRENT_BUILDTREES_DIR}/src/installer/msi" KINECTSDK20_MSI_EXTRACT_DIR)
file(TO_NATIVE_PATH "${CURRENT_BUILDTREES_DIR}/msiexec.log" MSIEXEC_LOG_PATH)
set(BATCH_FILE ${CURRENT_BUILDTREES_DIR}/msiextract-msmpi.bat)
file(WRITE ${BATCH_FILE} "msiexec.exe /a \"${KINECTSDK20_MSI_INSTALLER}\" /qn /log \"${MSIEXEC_LOG_PATH}\" TARGETDIR=\"${KINECTSDK20_MSI_EXTRACT_DIR}\"")
vcpkg_execute_required_process(
    COMMAND ${BATCH_FILE}
    WORKING_DIRECTORY ${CURRENT_BUILDTREES_DIR}
    LOGNAME extract_msi_installer
)

set(KINECTSDK20_DIR "${CURRENT_BUILDTREES_DIR}/src/installer/msi/Microsoft SDKs/Kinect/${KINECTSDK20_VERSION}")

file(
    INSTALL
        "${KINECTSDK20_DIR}/inc/Kinect.h"
    DESTINATION
        ${CURRENT_PACKAGES_DIR}/include
)

file(
    INSTALL
        "${KINECTSDK20_DIR}/Lib/${VCPKG_TARGET_ARCHITECTURE}/Kinect20.lib"
    DESTINATION
        ${CURRENT_PACKAGES_DIR}/lib
)

file(
    INSTALL
        "${KINECTSDK20_DIR}/Lib/${VCPKG_TARGET_ARCHITECTURE}/Kinect20.lib"
    DESTINATION
        ${CURRENT_PACKAGES_DIR}/debug/lib
)

# Handle copyright
file(COPY "${KINECTSDK20_DIR}/SDKEula.rtf" DESTINATION ${CURRENT_PACKAGES_DIR}/share/kinectsdk2)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/kinectsdk2/SDKEula.rtf ${CURRENT_PACKAGES_DIR}/share/kinectsdk2/copyright)
