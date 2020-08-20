## # vcpkg_build_make
##
## Build a linux makefile project.
##
## ## Usage:
## ```cmake
## vcpkg_build_make([BUILD_TARGET <target>]
##                  [ADD_BIN_TO_PATH]
##                  [ENABLE_INSTALL])
##                  [LOGFILE_ROOT <logfileroot>])
## ```
##
## ### BUILD_TARGET
## The target passed to the make build command (`./make <target>`). If not specified, the 'all' target will
## be passed.
##
## ### ADD_BIN_TO_PATH
## Adds the appropriate Release and Debug `bin\` directories to the path during the build such that executables can run against the in-tree DLLs.
##
## ### ENABLE_INSTALL
## IF the port supports the install target use vcpkg_install_make() instead of vcpkg_build_make()
##
## ### BUILD_TARGET
## The target passed to the make build command (`./make <target>`). If not specified, the 'all' target will
## be passed.
##
## ### DISABLE_PARALLEL
## The underlying buildsystem will be instructed to not parallelize
##
## ## Notes:
## This command should be preceeded by a call to [`vcpkg_configure_make()`](vcpkg_configure_make.md).
## You can use the alias [`vcpkg_install_make()`](vcpkg_configure_make.md) function if your CMake script supports the
## "install" target
##
## ## Examples
##
## * [x264](https://github.com/Microsoft/vcpkg/blob/master/ports/x264/portfile.cmake)
## * [tcl](https://github.com/Microsoft/vcpkg/blob/master/ports/tcl/portfile.cmake)
## * [freexl](https://github.com/Microsoft/vcpkg/blob/master/ports/freexl/portfile.cmake)
## * [libosip2](https://github.com/Microsoft/vcpkg/blob/master/ports/libosip2/portfile.cmake)
function(vcpkg_build_make)
    cmake_parse_arguments(_bc "ADD_BIN_TO_PATH;ENABLE_INSTALL;DISABLE_PARALLEL" "LOGFILE_ROOT;BUILD_TARGET" "" ${ARGN})

    if(NOT _bc_LOGFILE_ROOT)
        set(_bc_LOGFILE_ROOT "build")
    endif()

    if(NOT _bc_BUILD_TARGET)
        set(_bc_BUILD_TARGET "all")
    endif()

    if(WIN32)
        set(_VCPKG_PREFIX ${CURRENT_PACKAGES_DIR})
        set(_VCPKG_INSTALLED ${CURRENT_INSTALLED_DIR})
    else()
        string(REPLACE " " "\ " _VCPKG_PREFIX "${CURRENT_PACKAGES_DIR}")
        string(REPLACE " " "\ " _VCPKG_INSTALLED "${CURRENT_INSTALLED_DIR}")
    endif()

    set(MAKE )
    set(MAKE_OPTS )
    set(INSTALL_OPTS )
    if (CMAKE_HOST_WIN32)
        set(PATH_GLOBAL "$ENV{PATH}")
        vcpkg_add_to_path(PREPEND "${SCRIPTS}/buildsystems/make_wrapper")
        vcpkg_acquire_msys(MSYS_ROOT)
        find_program(MAKE make REQUIRED)
        set(MAKE_COMMAND "${MAKE}")
        set(MAKE_OPTS ${_bc_MAKE_OPTIONS} -j ${VCPKG_CONCURRENCY} --trace -f Makefile ${_bc_BUILD_TARGET})
        set(NO_PARALLEL_MAKE_OPTS ${_bc_MAKE_OPTIONS} -j 1 --trace -f Makefile ${_bc_BUILD_TARGET})

        string(REPLACE " " "\\\ " _VCPKG_PACKAGE_PREFIX ${CURRENT_PACKAGES_DIR})
        string(REGEX REPLACE "([a-zA-Z]):/" "/\\1/" _VCPKG_PACKAGE_PREFIX "${_VCPKG_PACKAGE_PREFIX}")
        set(INSTALL_OPTS -j ${VCPKG_CONCURRENCY} --trace -f Makefile install DESTDIR=${_VCPKG_PACKAGE_PREFIX})
        #TODO: optimize for install-data (release) and install-exec (release/debug)
    else()
        # Compiler requriements
        find_program(MAKE make REQUIRED)
        set(MAKE_COMMAND "${MAKE}")
        # Set make command and install command
        set(MAKE_OPTS ${_bc_MAKE_OPTIONS} V=1 -j ${VCPKG_CONCURRENCY} -f Makefile ${_bc_BUILD_TARGET})
        set(NO_PARALLEL_MAKE_OPTS ${_bc_MAKE_OPTIONS} V=1 -j 1 -f Makefile ${_bc_BUILD_TARGET})
        set(INSTALL_OPTS -j ${VCPKG_CONCURRENCY} install DESTDIR=${CURRENT_PACKAGES_DIR})
    endif()

    # Since includes are buildtype independent those are setup by vcpkg_configure_make
    _vcpkg_backup_env_variables(LIB LIBPATH LIBRARY_PATH LD_LIBRARY_PATH)

    foreach(BUILDTYPE "debug" "release")
        if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL BUILDTYPE)
            if(BUILDTYPE STREQUAL "debug")
                # Skip debug generate
                if (_VCPKG_NO_DEBUG)
                    continue()
                endif()
                set(SHORT_BUILDTYPE "-dbg")
                set(CMAKE_BUILDTYPE "DEBUG")
                set(PATH_SUFFIX "/debug")
            else()
                # In NO_DEBUG mode, we only use ${TARGET_TRIPLET} directory.
                if (_VCPKG_NO_DEBUG)
                    set(SHORT_BUILDTYPE "")
                else()
                    set(SHORT_BUILDTYPE "-rel")
                endif()
                set(CMAKE_BUILDTYPE "RELEASE")
                set(PATH_SUFFIX "")
            endif()

            set(WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}${SHORT_BUILDTYPE}")

            message(STATUS "Building ${TARGET_TRIPLET}${SHORT_BUILDTYPE}")

            set(ENV{LIB} "${_VCPKG_INSTALLED}${PATH_SUFFIX}/lib/${VCPKG_HOST_PATH_SEPARATOR}${_VCPKG_INSTALLED}${PATH_SUFFIX}/lib/manual-link/${LIB_PATHLIKE_CONCAT}")
            set(ENV{LIBPATH} "${_VCPKG_INSTALLED}${PATH_SUFFIX}/lib/${VCPKG_HOST_PATH_SEPARATOR}${_VCPKG_INSTALLED}${PATH_SUFFIX}/lib/manual-link/${LIBPATH_PATHLIKE_CONCAT}")
            set(ENV{LIBRARY_PATH} "${_VCPKG_INSTALLED}${PATH_SUFFIX}/lib/${VCPKG_HOST_PATH_SEPARATOR}${_VCPKG_INSTALLED}${PATH_SUFFIX}/lib/manual-link/${LIBRARY_PATH_PATHLIKE_CONCAT}")
            #set(ENV{LD_LIBRARY_PATH} "${_VCPKG_INSTALLED}${PATH_SUFFIX_${BUILDTYPE}}/lib/${VCPKG_HOST_PATH_SEPARATOR}${_VCPKG_INSTALLED}${PATH_SUFFIX_${BUILDTYPE}}/lib/manual-link/${LD_LIBRARY_PATH_PATHLIKE_CONCAT}")

            if(_bc_ADD_BIN_TO_PATH)
                set(_BACKUP_ENV_PATH "$ENV{PATH}")
                vcpkg_add_to_path(PREPEND "${CURRENT_INSTALLED_DIR}${PATH_SUFFIX}/bin")
            endif()

            if(MAKE_BASH)
                set(MAKE_CMD_LINE "${MAKE_COMMAND} ${MAKE_OPTS}")
                set(NO_PARALLEL_MAKE_CMD_LINE "${MAKE_COMMAND} ${NO_PARALLEL_MAKE_OPTS}")
            else()
                set(MAKE_CMD_LINE ${MAKE_COMMAND} ${MAKE_OPTS})
                set(NO_PARALLEL_MAKE_CMD_LINE ${MAKE_COMMAND} ${NO_PARALLEL_MAKE_OPTS})
            endif()
            if (_bc_DISABLE_PARALLEL)
                vcpkg_execute_build_process(
                        COMMAND ${MAKE_BASH} ${MAKE_CMD_LINE}
                        WORKING_DIRECTORY "${WORKING_DIRECTORY}"
                        LOGNAME "${_bc_LOGFILE_ROOT}-${TARGET_TRIPLET}${SHORT_BUILDTYPE}"
                )
            else()
            vcpkg_execute_build_process(
                    COMMAND ${MAKE_BASH} ${MAKE_CMD_LINE}
                    NO_PARALLEL_COMMAND ${MAKE_BASH} ${NO_PARALLEL_MAKE_CMD_LINE}
                    WORKING_DIRECTORY "${WORKING_DIRECTORY}"
                    LOGNAME "${_bc_LOGFILE_ROOT}-${TARGET_TRIPLET}${SHORT_BUILDTYPE}"
            )
            endif()

            if(_bc_ADD_BIN_TO_PATH)
                set(ENV{PATH} "${_BACKUP_ENV_PATH}")
            endif()
        endif()
    endforeach()

    if (_bc_ENABLE_INSTALL)
        foreach(BUILDTYPE "debug" "release")
            if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL BUILDTYPE)
                if(BUILDTYPE STREQUAL "debug")
                    # Skip debug generate
                    if (_VCPKG_NO_DEBUG)
                        continue()
                    endif()
                    set(SHORT_BUILDTYPE "-dbg")
                else()
                    # In NO_DEBUG mode, we only use ${TARGET_TRIPLET} directory.
                    if (_VCPKG_NO_DEBUG)
                        set(SHORT_BUILDTYPE "")
                    else()
                        set(SHORT_BUILDTYPE "-rel")
                    endif()
                endif()

                message(STATUS "Installing ${TARGET_TRIPLET}${SHORT_BUILDTYPE}")

                if(MAKE_BASH)
                    set(MAKE_CMD_LINE "${MAKE_COMMAND} ${INSTALL_OPTS}")
                else()
                    set(MAKE_CMD_LINE ${MAKE_COMMAND} ${INSTALL_OPTS})
                endif()

                set(WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}${SHORT_BUILDTYPE}")
                vcpkg_execute_build_process(
                    COMMAND ${MAKE_BASH} ${MAKE_CMD_LINE}
                    WORKING_DIRECTORY "${WORKING_DIRECTORY}"
                    LOGNAME "install-${TARGET_TRIPLET}${SHORT_BUILDTYPE}"
                )

            endif()
        endforeach()
        string(REGEX REPLACE "([a-zA-Z]):/" "/\\1/" _VCPKG_INSTALL_PREFIX "${CURRENT_INSTALLED_DIR}")
        file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}_tmp")
        file(RENAME "${CURRENT_PACKAGES_DIR}" "${CURRENT_PACKAGES_DIR}_tmp")
        file(RENAME "${CURRENT_PACKAGES_DIR}_tmp${_VCPKG_INSTALL_PREFIX}/" "${CURRENT_PACKAGES_DIR}")
        file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}_tmp")
    endif()

    if (CMAKE_HOST_WIN32)
        set(ENV{PATH} "${PATH_GLOBAL}")
    endif()

    _vcpkg_restore_env_variables(LIB LIBPATH LIBRARY_PATH LD_LIBRARY_PATH)
endfunction()
