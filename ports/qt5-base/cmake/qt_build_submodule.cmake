
function(qt_build_submodule SOURCE_PATH)
    # This fixes issues on machines with default codepages that are not ASCII compatible, such as some CJK encodings
    set(ENV{_CL_} "/utf-8")

    vcpkg_find_acquire_program(PYTHON2)
    get_filename_component(PYTHON2_EXE_PATH ${PYTHON2} DIRECTORY)
    vcpkg_add_to_path("${PYTHON2_EXE_PATH}")
    
    vcpkg_configure_qmake(SOURCE_PATH ${SOURCE_PATH} ${ARGV})

    vcpkg_build_qmake(SKIP_MAKEFILES)
    
    #Fix the installation location within the makefiles
    qt_fix_makefile_install("${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/")
    qt_fix_makefile_install("${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/")
    
    #Install the module files
    vcpkg_build_qmake(TARGETS install SKIP_MAKEFILES BUILD_LOGNAME install)
    
    qt_fix_cmake(${CURRENT_PACKAGES_DIR} ${PORT})

    #Replace with VCPKG variables if PR #7733 is merged
    unset(BUILDTYPES)
    if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
        set(_buildname "DEBUG")
        list(APPEND BUILDTYPES ${_buildname})
        set(_short_name_${_buildname} "dbg")
        set(_path_suffix_${_buildname} "/debug")        
    endif()
    if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
        set(_buildname "RELEASE")
        list(APPEND BUILDTYPES ${_buildname})
        set(_short_name_${_buildname} "rel")
        set(_path_suffix_${_buildname} "")        
    endif()
    unset(_buildname)

    foreach(_buildname ${BUILDTYPES})
        set(CURRENT_BUILD_PACKAGE_DIR "${CURRENT_PACKAGES_DIR}${_path_suffix_${_buildname}}")
        #Fix PRL files 
        file(GLOB_RECURSE PRL_FILES "${CURRENT_BUILD_PACKAGE_DIR}/lib/*.prl" "${CURRENT_PACKAGES_DIR}/tools/qt5${_path_suffix_${_buildname}}/lib/*.prl" 
                                    "${CURRENT_PACKAGES_DIR}/tools/qt5${_path_suffix_${_buildname}}/mkspecs/*.pri")
        qt_fix_prl("${CURRENT_BUILD_PACKAGE_DIR}" "${PRL_FILES}")
        
        # This makes it impossible to use the build tools in any meaningful way. qt5 assumes they are all in one folder!
        # So does the Qt VS Plugin which even assumes all of the in a bin folder  
        #Move tools to the correct directory
        #if(EXISTS ${CURRENT_BUILD_PACKAGE_DIR}/tools/qt5)
        #    file(RENAME ${CURRENT_BUILD_PACKAGE_DIR}/tools/qt5 ${CURRENT_PACKAGES_DIR}/tools/${PORT})
        #endif()
        
        # Move executables in bin to tools
        # This is ok since those are not build tools.
        file(GLOB PACKAGE_EXE ${CURRENT_BUILD_PACKAGE_DIR}/bin/*.exe)
        if(PACKAGE_EXE)
            file(INSTALL ${PACKAGE_EXE} DESTINATION "${CURRENT_BUILD_PACKAGE_DIR}/tools/${PORT}")
            file(REMOVE ${PACKAGE_EXE})
            foreach(_exe ${PACKAGE_EXE})
                string(REPLACE ".exe" ".pdb" _prb_file ${_exe})
                if(EXISTS ${_prb_file})
                    file(INSTALL ${_prb_file} DESTINATION "${CURRENT_BUILD_PACKAGE_DIR}/tools/${PORT}")
                    file(REMOVE ${_prb_file})
                endif()
            endforeach()
        endif()
        
        #cleanup empty folders
        file(GLOB PACKAGE_LIBS "${CURRENT_BUILD_PACKAGE_DIR}/lib/*")
        if(NOT PACKAGE_LIBS)
            file(REMOVE_RECURSE "${CURRENT_BUILD_PACKAGE_DIR}/lib")
        endif()
        
        file(GLOB PACKAGE_BINS "${CURRENT_BUILD_PACKAGE_DIR}/bin/*")
        if(NOT PACKAGE_BINS)
            file(REMOVE_RECURSE "${CURRENT_BUILD_PACKAGE_DIR}/bin")
        endif()
    endforeach()
    if(EXISTS "${CURRENT_PACKAGES_DIR}/tools/qt5/bin")
        file(COPY "${CURRENT_PACKAGES_DIR}/tools/qt5/bin" DESTINATION "${CURRENT_PACKAGES_DIR}/tools/${PORT}")
        
        set(CURRENT_INSTALLED_DIR_BACKUP "${CURRENT_INSTALLED_DIR}")
        set(CURRENT_INSTALLED_DIR "./../../.." ) # Making the qt.conf relative and not absolute
        configure_file(${CURRENT_INSTALLED_DIR_BACKUP}/tools/qt5/qt_release.conf ${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin/qt.conf) # This makes the tools at least useable for release
        set(CURRENT_INSTALLED_DIR "${CURRENT_INSTALLED_DIR_BACKUP}")
        
        vcpkg_copy_tool_dependencies("${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin")
        if(VCPKG_TARGET_IS_WINDOWS AND VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
            file(GLOB_RECURSE DLL_DEPS_AVAIL "${CURRENT_INSTALLED_DIR}/tools/qt5/bin/*.dll")
            string(REPLACE "${CURRENT_INSTALLED_DIR}/tools/qt5/bin/" "" DLL_DEPS_AVAIL "${DLL_DEPS_AVAIL}")
            file(GLOB_RECURSE DLL_DEPS_NEEDED "${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin/*.dll")
            string(REPLACE "${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin/" "" DLL_DEPS_NEEDED "${DLL_DEPS_NEEDED}")
            if(DLL_DEPS_AVAIL AND DLL_DEPS_NEEDED)
                list(REMOVE_ITEM DLL_DEPS_NEEDED ${DLL_DEPS_AVAIL})
            endif()
            foreach(dll_dep ${DLL_DEPS_NEEDED})
                string(REGEX REPLACE "[^/]+$" "" dll_subpath "${dll_dep}")
                file(COPY "${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin/${dll_dep}" DESTINATION "${CURRENT_PACKAGES_DIR}/tools/qt5/bin/${dll_subpath}")
            endforeach()
        endif()
    endif()
    
    #This should be removed if somehow possible
    if(EXISTS "${CURRENT_PACKAGES_DIR}/debug/tools/qt5/bin")
        file(COPY "${CURRENT_PACKAGES_DIR}/debug/tools/qt5/bin" DESTINATION "${CURRENT_PACKAGES_DIR}/tools/${PORT}/debug")
        
        set(CURRENT_INSTALLED_DIR_BACKUP "${CURRENT_INSTALLED_DIR}")
        set(CURRENT_INSTALLED_DIR "./../../../.." ) # Making the qt.conf relative and not absolute
        configure_file(${CURRENT_INSTALLED_DIR_BACKUP}/tools/qt5/qt_debug.conf ${CURRENT_PACKAGES_DIR}/tools/${PORT}/debug/bin/qt.conf) # This makes the tools at least useable for release
        set(CURRENT_INSTALLED_DIR "${CURRENT_INSTALLED_DIR_BACKUP}")
        
        vcpkg_copy_tool_dependencies("${CURRENT_PACKAGES_DIR}/tools/${PORT}/debug/bin")
        if(VCPKG_TARGET_IS_WINDOWS AND VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
            file(GLOB_RECURSE DLL_DEPS_AVAIL "${CURRENT_INSTALLED_DIR}/tools/qt5/debug/bin/*.dll")
            string(REPLACE "${CURRENT_INSTALLED_DIR}/tools/qt5/debug/bin/" "" DLL_DEPS_AVAIL "${DLL_DEPS_AVAIL}")
            file(GLOB_RECURSE DLL_DEPS_NEEDED "${CURRENT_PACKAGES_DIR}/tools/${PORT}/debug/bin/*.dll")
            string(REPLACE "${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin/" "" DLL_DEPS_NEEDED "${DLL_DEPS_NEEDED}")
            if(DLL_DEPS_AVAIL AND DLL_DEPS_NEEDED)
                list(REMOVE_ITEM DLL_DEPS_NEEDED ${DLL_DEPS_AVAIL})
            endif()
            foreach(dll_dep ${DLL_DEPS_NEEDED})
                string(REGEX REPLACE "[^/]+$" "" dll_subpath "${dll_dep}")
                file(COPY "${CURRENT_PACKAGES_DIR}/tools/${PORT}/debug/bin/${dll_dep}" DESTINATION "${CURRENT_PACKAGES_DIR}/tools/qt5/debug/bin/${dll_subpath}")
            endforeach()
        endif()
    endif()
    
endfunction()