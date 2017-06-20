# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/QScintilla_gpl-2.10)
vcpkg_download_distfile(ARCHIVE
    URLS "https://sourceforge.net/projects/pyqt/files/QScintilla2/QScintilla-2.10/QScintilla_gpl-2.10.zip"
    FILENAME "QScintilla_gpl-2.10.zip"
    SHA512 7c580cfee03af1056f530af756a0ff9cc2396a5419fa23aecc66a6bc8809a4fb154788956220bb0b068a5c214d571c053271c3906d6d541196fbbf7c6dbec917
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_find_acquire_program(PYTHON3)

# Add python3 to path
SET(ENV{PATH} "${DOWNLOADS}/tools/python;$ENV{PATH}")

vcpkg_configure_qmake(
    SOURCE_PATH "${SOURCE_PATH}/Qt4Qt5"
    OPTIONS
        CONFIG+=build_all
        CONFIG-=hide_symbols
)

vcpkg_build_qmake()

# Install following vcpkg conventions (following qwt portfile)
set(BUILD_DIR ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET})

file(GLOB HEADER_FILES ${SOURCE_PATH}/include/*)
file(INSTALL ${HEADER_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/include/qscintilla)

file(INSTALL
    ${BUILD_DIR}/release/qscintilla2_qt5.lib
    DESTINATION ${CURRENT_PACKAGES_DIR}/lib
)

file(INSTALL
    ${BUILD_DIR}/debug/qscintilla2_qt5.lib
    DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    file(INSTALL
        ${BUILD_DIR}/release/qscintilla2_qt5.dll
        DESTINATION ${CURRENT_PACKAGES_DIR}/bin
    )

    file(INSTALL
        ${BUILD_DIR}/debug/qscintilla2_qt5.dll
        ${BUILD_DIR}/debug/qscintilla2_qt5.pdb
        DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin
    )
endif()

# Handle copyright
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/qscintilla)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/qscintilla/LICENSE ${CURRENT_PACKAGES_DIR}/share/qscintilla/copyright)
