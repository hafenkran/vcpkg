include(vcpkg_common_functions)

string(LENGTH "${CURRENT_BUILDTREES_DIR}" BUILDTREES_PATH_LENGTH)
if(BUILDTREES_PATH_LENGTH GREATER 37)
    message(WARNING "Qt5's buildsystem uses very long paths and may fail on your system.\n"
        "We recommend moving vcpkg to a short path such as 'C:\\src\\vcpkg' or using the subst command."
    )
endif()

if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    message(FATAL_ERROR "Qt5 doesn't currently support static builds. Please use a dynamic triplet instead.")
endif()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

set(SRCDIR_NAME "qtxmlpatterns-5.9.2")
set(ARCHIVE_NAME "qtxmlpatterns-opensource-src-5.9.2")
set(ARCHIVE_EXTENSION ".tar.xz")

set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/${SRCDIR_NAME})
vcpkg_download_distfile(ARCHIVE_FILE
    URLS "http://download.qt.io/official_releases/qt/5.9/5.9.2/submodules/${ARCHIVE_NAME}${ARCHIVE_EXTENSION}"
    FILENAME ${SRCDIR_NAME}${ARCHIVE_EXTENSION}
    SHA512 c14dbd97988473ba73b4e21352c5560278aa4dbfdf2be1d12e9119c0b5dbe8a0e4eff9a682052024a01bb21dcf52d40ba00da98947901fb91518af92a225da83
)
vcpkg_extract_source_archive(${ARCHIVE_FILE})
if (EXISTS ${CURRENT_BUILDTREES_DIR}/src/${ARCHIVE_NAME})
    file(RENAME ${CURRENT_BUILDTREES_DIR}/src/${ARCHIVE_NAME} ${CURRENT_BUILDTREES_DIR}/src/${SRCDIR_NAME})
endif()

# This fixes issues on machines with default codepages that are not ASCII compatible, such as some CJK encodings
set(ENV{_CL_} "/utf-8")

vcpkg_configure_qmake_debug(
    SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/${SRCDIR_NAME}
)

vcpkg_build_qmake_debug()

vcpkg_configure_qmake_release(
    SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/${SRCDIR_NAME}
)

vcpkg_build_qmake_release()

vcpkg_find_acquire_program(PYTHON3)
get_filename_component(PYTHON3_EXE_PATH ${PYTHON3} DIRECTORY)
set(ENV{PATH} "${PYTHON3_EXE_PATH};$ENV{PATH}")
set(_path "$ENV{PATH}")

set(DEBUG_DIR "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg")
set(RELEASE_DIR "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel")

vcpkg_execute_required_process(
    COMMAND ${PYTHON3} ${CMAKE_CURRENT_LIST_DIR}/fixcmake.py
    WORKING_DIRECTORY ${RELEASE_DIR}/lib/cmake
    LOGNAME fix-cmake
)

set(ENV{PATH} "${_path}")

file(INSTALL ${DEBUG_DIR}/bin DESTINATION ${CURRENT_PACKAGES_DIR}/debug)
file(INSTALL ${DEBUG_DIR}/lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug)
file(INSTALL ${DEBUG_DIR}/include DESTINATION ${CURRENT_PACKAGES_DIR}/share/qt5/debug)
file(INSTALL ${DEBUG_DIR}/mkspecs DESTINATION ${CURRENT_PACKAGES_DIR}/share/qt5/debug)

file(INSTALL ${RELEASE_DIR}/bin DESTINATION ${CURRENT_PACKAGES_DIR})
file(INSTALL ${RELEASE_DIR}/lib DESTINATION ${CURRENT_PACKAGES_DIR})
file(INSTALL ${RELEASE_DIR}/include DESTINATION ${CURRENT_PACKAGES_DIR})
file(INSTALL ${RELEASE_DIR}/mkspecs DESTINATION ${CURRENT_PACKAGES_DIR}/share/qt5)

file(GLOB BINARY_TOOLS "${CURRENT_PACKAGES_DIR}/bin/*.exe")
file(INSTALL ${BINARY_TOOLS} DESTINATION ${CURRENT_PACKAGES_DIR}/tools/qt5)
file(REMOVE ${BINARY_TOOLS})
file(GLOB BINARY_TOOLS "${CURRENT_PACKAGES_DIR}/debug/bin/*.exe")
file(INSTALL ${BINARY_TOOLS} DESTINATION ${CURRENT_PACKAGES_DIR}/debug/tools/qt5)
file(REMOVE ${BINARY_TOOLS})

file(RENAME ${CURRENT_PACKAGES_DIR}/lib/cmake ${CURRENT_PACKAGES_DIR}/share/cmake)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/cmake)

file(GLOB RELEASE_DLLS "${CURRENT_PACKAGES_DIR}/lib/*.dll")
file(GLOB DEBUG_DLLS "${CURRENT_PACKAGES_DIR}/debug/lib/*.dll")
file(REMOVE ${RELEASE_DLLS} ${DEBUG_DLLS})

file(INSTALL ${SOURCE_PATH}/LICENSE.LGPLv3 DESTINATION ${CURRENT_PACKAGES_DIR}/share/qt5xmlpatterns RENAME copyright)