## # vcpkg_copy_pdbs
##
## Automatically locate pdbs in the build tree and copy them adjacent to all DLLs.
##
## ## Usage
## ```cmake
## vcpkg_copy_pdbs()
## ```
##
## ## Notes
## This command should always be called by portfiles after they have finished rearranging the binary output.
##
## ## Examples
##
## * [zlib](https://github.com/Microsoft/vcpkg/blob/master/ports/zlib/portfile.cmake)
## * [cpprestsdk](https://github.com/Microsoft/vcpkg/blob/master/ports/cpprestsdk/portfile.cmake)
function(vcpkg_copy_pdbs)

    function(merge_filelist OUTVAR INVAR)
        set(MSG "")
        foreach(VAR ${${INVAR}})
            set(MSG "${MSG}    ${VAR}\n")
        endforeach()
        set(${OUTVAR} ${MSG} PARENT_SCOPE)
    endfunction()

    if(VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
        file(GLOB_RECURSE DLLS ${CURRENT_PACKAGES_DIR}/bin/*.dll ${CURRENT_PACKAGES_DIR}/debug/bin/*.dll)

        set(DLLS_WITHOUT_MATCHING_PDBS)

        set(PREVIOUS_VSLANG $ENV{VSLANG})
        set(ENV{VSLANG} 1033)

        foreach(DLL ${DLLS})
            execute_process(COMMAND dumpbin /PDBPATH ${DLL}
                            COMMAND findstr PDB
                OUTPUT_VARIABLE PDB_LINE
                ERROR_QUIET
                RESULT_VARIABLE error_code
            )

            if(NOT error_code AND PDB_LINE MATCHES "PDB file found at")
                string(REGEX MATCH '.*' PDB_PATH ${PDB_LINE}) # Extract the path which is in single quotes
                string(REPLACE ' "" PDB_PATH ${PDB_PATH}) # Remove single quotes
                get_filename_component(DLL_DIR ${DLL} DIRECTORY)
                file(COPY ${PDB_PATH} DESTINATION ${DLL_DIR})
            else()
                list(APPEND DLLS_WITHOUT_MATCHING_PDBS ${DLL})
            endif()
        endforeach()

        set(ENV{VSLANG} ${PREVIOUS_VSLANG})

        list(LENGTH DLLS_WITHOUT_MATCHING_PDBS UNMATCHED_DLLS_LENGTH)
        if(UNMATCHED_DLLS_LENGTH GREATER 0)
            merge_filelist(MSG DLLS_WITHOUT_MATCHING_PDBS)
            message(STATUS "Warning: Could not find a matching pdb file for:\n${MSG}")
        endif()
    endif()

endfunction()