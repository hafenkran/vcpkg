set(PORT_VERSION 12.2)

macro(feature_unsupported)
    foreach(_feat ${ARGN})
        if("${FEATURES}" MATCHES "${_feat}")
            message(FATAL_ERROR "Feature ${_feat} not supported by configure script on the target platform")
        endif()
    endforeach()
endmacro()

macro(feature_not_implemented_yet)
    foreach(_feat ${ARGN})
        if("${FEATURES}" MATCHES "${_feat}")
            message(FATAL_ERROR "Feature ${_feat} is not yet implement on the target platform")
        endif()
    endforeach()
endmacro()

if(VCPKG_TARGET_IS_WINDOWS)
    # on windows libpq seems to only depend on openssl gss(kerberos) and ldap on the soruce site_name
    # the configuration header depends on zlib, nls, ldap, uuid, xml, xlst,gss,openssl,icu
    feature_unsupported(readline bonjour libedit kerberos bsd systemd llvm pam)
    feature_not_implemented_yet(perl uuid)
elseif(VCPKG_TARGET_IS_OSX)
    feature_not_implemented_yet(readline libedit kerberos bsd systemd llvm pam perl python tcl uuid)
else()
    feature_not_implemented_yet(readline bonjour libedit kerberos bsd systemd llvm pam perl python tcl uuid)
endif()

## Download and extract sources
vcpkg_download_distfile(ARCHIVE
    URLS "https://ftp.postgresql.org/pub/source/v${PORT_VERSION}/postgresql-${PORT_VERSION}.tar.bz2"
    FILENAME "postgresql-${PORT_VERSION}.tar.bz2"
    SHA512 0e0ce8e21856e8f43e58b840c10c4e3ffae6d5207e0d778e9176e36f8e20e34633cbb06f0030a7c963c3491bb7e941456d91b55444c561cfc6f283fba76f33ee
)

set(PATCHES
        patches/windows/install.patch
        patches/windows/win_bison_flex.patch
        patches/windows/openssl_exe_path.patch
        patches/windows/Solution.patch
        patches/windows/MSBuildProject_fix_gendef_perl.patch
        patches/windows/msgfmt.patch
        patches/windows/python_lib.patch
        patches/linux/configure.patch)

if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    list(APPEND PATCHES patches/windows/MSBuildProject-static-lib.patch)
    list(APPEND PATCHES patches/windows/Mkvcbuild-static-lib.patch)
endif()
if(VCPKG_CRT_LINKAGE STREQUAL static)
    list(APPEND PATCHES patches/windows/MSBuildProject-static-crt.patch)
endif()
if(VCPKG_TARGET_ARCHITECTURE MATCHES "arm")
    list(APPEND PATCHES patches/windows/arm.patch)
    list(APPEND PATCHES patches/windows/host_skip_openssl.patch) # Skip openssl.exe version check since it cannot be executed by the host
endif()
if(NOT "${FEATURES}" MATCHES "client")
    list(APPEND PATCHES patches/windows/minimize_install.patch)
else()
    set(HAS_TOOLS TRUE)
endif()
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    PATCHES ${PATCHES}
)
unset(buildenv_contents)
# Get paths to required programs
foreach(program_name BISON FLEX PERL)
    # Need to rename win_bison and win_flex to just bison and flex
    vcpkg_find_acquire_program(${program_name})
    get_filename_component(${program_name}_EXE_PATH ${${program_name}} DIRECTORY)
    vcpkg_add_to_path(PREPEND "${${program_name}_EXE_PATH}")
    set(buildenv_contents "${buildenv_contents}\n\$ENV{'PATH'}=\$ENV{'PATH'} . ';${${program_name}_EXE_PATH}';")
endforeach()

## Setup build types
if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE MATCHES "[Rr][Ee][Ll][Ee][Aa][Ss][Ee]")
    set(_buildtype RELEASE)
    set(_short rel)
    list(APPEND port_config_list ${_buildtype})
    set(INSTALL_PATH_SUFFIX_${_buildtype} "")
    set(BUILDPATH_${_buildtype} "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-${_short}")
    file(REMOVE_RECURSE "${BUILDPATH_${_buildtype}}") #Clean old builds
    set(PACKAGE_DIR_${_buildtype} ${CURRENT_PACKAGES_DIR})
    unset(_short)
    unset(_buildtype)
endif()
if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE MATCHES "[Dd][Ee][Bb][Uu][Gg]")
    set(_buildtype DEBUG)
    set(_short dbg)
    list(APPEND port_config_list ${_buildtype})
    set(INSTALL_PATH_SUFFIX_${_buildtype} "/debug")
    set(BUILDPATH_${_buildtype} "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-${_short}")
    file(REMOVE_RECURSE "${BUILDPATH_${_buildtype}}") #Clean old builds
    set(PACKAGE_DIR_${_buildtype} ${CURRENT_PACKAGES_DIR}${INSTALL_PATH_SUFFIX_${_buildtype}})
    unset(_short)
    unset(_buildtype)
endif()

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/share/${PORT})

## Do the build
if(VCPKG_TARGET_IS_WINDOWS)
    file(GLOB SOURCE_FILES ${SOURCE_PATH}/*)
    foreach(_buildtype ${port_config_list})
        # Copy libpq sources.
        message(STATUS "Copying libpq source files to ${BUILDPATH_${_buildtype}}...")
        foreach(SOURCE_FILE ${SOURCE_FILES})
            file(COPY ${SOURCE_FILE} DESTINATION "${BUILDPATH_${_buildtype}}")
        endforeach()
        message(STATUS "Copying libpq source files... done")
        
        vcpkg_apply_patches(
            SOURCE_PATH "${BUILDPATH_${_buildtype}}"
            PATCHES patches/windows/Solution_${_buildtype}.patch
                    patches/windows/python3_build_${_buildtype}.patch
        )
        message(STATUS "Patches applied!")
        file(COPY "${CURRENT_PORT_DIR}/config.pl" DESTINATION "${BUILDPATH_${_buildtype}}/src/tools/msvc")
        
        set(MSPROJ_PERL "${BUILDPATH_${_buildtype}}/src/tools/msvc/MSBuildProject.pm")
        file(READ "${MSPROJ_PERL}" _contents)
        string(REPLACE "perl" "\"${PERL}\"" _contents "${_contents}")
        file(WRITE "${MSPROJ_PERL}" "${_contents}")
        
        set(CONFIG_FILE "${BUILDPATH_${_buildtype}}/src/tools/msvc/config.pl")
        file(READ "${CONFIG_FILE}" _contents)
        
        ##	ldap      => undef,    # --with-ldap                            ##done
        ##	extraver  => undef,    # --with-extra-version=<string>
        ##	gss       => undef,    # --with-gssapi=<path>
        ##	icu       => undef,    # --with-icu=<path>                      ##done
        ##	nls       => undef,    # --enable-nls=<path>                    ##done
        ##	tap_tests => undef,    # --enable-tap-tests
        ##	tcl       => undef,    # --with-tcl=<path>                      #done
        ##	perl      => undef,    # --with-perl                            # requires a patch to the lib path and a port for it
        ##	python    => undef,    # --with-python=<path>                   ##done
        ##	openssl   => undef,    # --with-openssl=<path>                  ##done
        ##	uuid      => undef,    # --with-ossp-uuid
        ##	xml       => undef,    # --with-libxml=<path>                   ##done
        ##	xslt      => undef,    # --with-libxslt=<path>                  ##done
        ##	iconv     => undef,    # (not in configure, path to iconv)      ##done (needed by xml)
        ##	zlib      => undef     # --with-zlib=<path>                     ##done
        
        ## Setup external dependencies
        ##"-DFEATURES=core;openssl;zlib" "-DALL_FEATURES=openssl;zlib;readline;libedit;perl;python;tcl;nls;kerberos;systemd;ldap;bsd;pam;llvm;icu;bonjour;uuid;xml;xslt;"
        if("${FEATURES}" MATCHES "ldap")
            string(REPLACE "ldap      => undef" "ldap      => 1" _contents "${_contents}")
        endif()
        if("${FEATURES}" MATCHES "icu")
           string(REPLACE "icu       => undef" "icu      => \"${CURRENT_INSTALLED_DIR}\"" _contents "${_contents}")
        endif()
        if("${FEATURES}" MATCHES "nls")
           string(REPLACE "nls       => undef" "nls      => \"${CURRENT_INSTALLED_DIR}\"" _contents "${_contents}")
           vcpkg_acquire_msys(MSYS_ROOT PACKAGES gettext)
           vcpkg_add_to_path("${MSYS_ROOT}/usr/bin")
        endif()
        if("${FEATURES}" MATCHES "openssl")
            set(buildenv_contents "${buildenv_contents}\n\$ENV{'PATH'}=\$ENV{'PATH'} . ';${CURRENT_INSTALLED_DIR}/tools/openssl';")
            #set(_contents "${_contents}\n\$ENV{PATH}=\$ENV{PATH} . ';${CURRENT_INSTALLED_DIR}/tools/openssl';")
            string(REPLACE "openssl   => undef" "openssl   => \"${CURRENT_INSTALLED_DIR}\"" _contents "${_contents}")
        endif()
        if("${FEATURES}" MATCHES "python")
           #vcpkg_find_acquire_program(PYTHON3)
           #get_filename_component(PYTHON3_EXE_PATH ${PYTHON3} DIRECTORY)
           #vcpkg_add_to_path("${PYTHON3_EXE_PATH}")
           string(REPLACE "python    => undef" "python    => \"${CURRENT_INSTALLED_DIR}\"" _contents "${_contents}")
        endif()
        if("${FEATURES}" MATCHES "tcl")
           string(REPLACE "tcl       => undef" "tcl       => \"${CURRENT_INSTALLED_DIR}\"" _contents "${_contents}")
        endif()
        if("${FEATURES}" MATCHES "xml")
           string(REPLACE "xml       => undef" "xml      => \"${CURRENT_INSTALLED_DIR}\"" _contents "${_contents}")
           string(REPLACE "iconv     => undef" "iconv      => \"${CURRENT_INSTALLED_DIR}\"" _contents "${_contents}")
        endif()

        if("${FEATURES}" MATCHES "xslt")
           string(REPLACE "xslt      => undef" "xslt      => \"${CURRENT_INSTALLED_DIR}\"" _contents "${_contents}")
        endif()

        if("${FEATURES}" MATCHES "zlib")
           string(REPLACE "zlib      => undef" "zlib      => \"${CURRENT_INSTALLED_DIR}\"" _contents "${_contents}")
        endif()
        
        file(WRITE "${CONFIG_FILE}" "${_contents}")
        file(WRITE "${BUILDPATH_${_buildtype}}/src/tools/msvc/buildenv.pl" "${buildenv_contents}")
        vcpkg_get_windows_sdk(VCPKG_TARGET_PLATFORM_VERSION)
        set(ENV{MSBFLAGS} "/p:PlatformToolset=${VCPKG_PLATFORM_TOOLSET}
            /p:VCPkgLocalAppDataDisabled=true
            /p:UseIntelMKL=No
            /p:WindowsTargetPlatformVersion=${VCPKG_TARGET_PLATFORM_VERSION}
            /m
            /p:ForceImportBeforeCppTargets=\"${SCRIPTS}/buildsystems/msbuild/vcpkg.targets\"
            /p:VcpkgTriplet=${TARGET_TRIPLET}"
            )
        if(HAS_TOOLS)
            if(VCPKG_TARGET_ARCHITECTURE STREQUAL x86)
                set(ENV{MSBFLAGS} "$ENV{MSBFLAGS} /p:Platform=Win32")
            endif()
            message(STATUS "Building libpq ${TARGET_TRIPLET}-${_buildtype}...")
            vcpkg_execute_required_process(
                COMMAND ${PERL} build.pl ${_buildtype}
                WORKING_DIRECTORY ${BUILDPATH_${_buildtype}}/src/tools/msvc
                LOGNAME build-${TARGET_TRIPLET}-${_buildtype}
            )
            message(STATUS "Building libpq ${TARGET_TRIPLET}-${_buildtype}... done")
        else()
            set(build_libs libpq libecpg_compat)
            foreach(build_lib ${build_libs})
                message(STATUS "Building ${build_lib} ${TARGET_TRIPLET}-${_buildtype}...")
                vcpkg_execute_required_process(
                    COMMAND ${PERL} build.pl ${_buildtype} ${build_lib}
                    WORKING_DIRECTORY ${BUILDPATH_${_buildtype}}/src/tools/msvc
                    LOGNAME build-${build_lib}-${TARGET_TRIPLET}-${_buildtype}
                )
                message(STATUS "Building ${build_lib} ${TARGET_TRIPLET}-${_buildtype}... done")
            endforeach()
        endif()

        message(STATUS "Installing libpq ${TARGET_TRIPLET}-${_buildtype}...")
        vcpkg_execute_required_process(
            COMMAND ${PERL} install.pl ${CURRENT_PACKAGES_DIR}${INSTALL_PATH_SUFFIX_${_buildtype}} client
            WORKING_DIRECTORY ${BUILDPATH_${_buildtype}}/src/tools/msvc
            LOGNAME install-${TARGET_TRIPLET}-${_buildtype}
        )
        message(STATUS "Installing libpq ${TARGET_TRIPLET}-${_buildtype}... done")
    endforeach()


    message(STATUS "Cleanup libpq ${TARGET_TRIPLET}...")
    #Cleanup
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/doc)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/tools)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/symbols)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/symbols)

    if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
        file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
    endif()
    
    if(NOT HAS_TOOLS)
        file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/tools)
    else()
        vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/${PORT})
    endif()
    #file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/${PORT}/)
    #vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/${PORT})
    message(STATUS "Cleanup libpq ${TARGET_TRIPLET}... - done")
else()
    if("${FEATURES}" MATCHES "openssl")
        list(APPEND BUILD_OPTS --with-openssl)
    endif()
    if(NOT "${FEATURES}" MATCHES "zlib")
        list(APPEND BUILD_OPTS --without-zlib)
    endif()
    if(NOT "${FEATURES}" MATCHES "readline")
        list(APPEND BUILD_OPTS --without-readline)
    endif()
    vcpkg_configure_make(
        SOURCE_PATH ${SOURCE_PATH}
        OPTIONS
            ${BUILD_OPTS}
            --with-includes=${CURRENT_INSTALLED_DIR}/include
        OPTIONS_RELEASE
            --exec-prefix=${CURRENT_PACKAGES_DIR}/tools/${PORT}
            --datarootdir=${CURRENT_PACKAGES_DIR}/share/${PORT}
            --with-libraries=${CURRENT_INSTALLED_DIR}/lib
        OPTIONS_DEBUG
            --exec-prefix=${CURRENT_PACKAGES_DIR}/debug/tools/${PORT}
            --datarootdir=${CURRENT_PACKAGES_DIR}/debug/share/${PORT}
            --with-libraries=${CURRENT_INSTALLED_DIR}/debug/lib
            --enable-debug
    )

    vcpkg_install_make()
    # instead?
    #    make -C src/include install
    #    make -C src/interfaces install
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/bin)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
    if(NOT HAS_TOOLS)
        file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin)
    else()
        file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/${PORT})
        file(RENAME ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/tools/${PORT})
    endif()
endif()
#vcpkg_copy_pdbs()

#if(EXISTS "${CURRENT_PACKAGES_DIR}/debug/lib/libpq.lib")
    #RENAME debug library due to CMake. In general that is a bad idea but it will have consquences for the generated cmake targets 
    # of other ports if not renamed. Maybe a vcpkg_cmake_wrapper is required here to correct the target information if the rename is removed?
#    file(RENAME "${CURRENT_PACKAGES_DIR}/debug/lib/libpq.lib" "${CURRENT_PACKAGES_DIR}/debug/lib/libpqd.lib")
#endif()

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/share/postgresql)
file(INSTALL ${CURRENT_PORT_DIR}/vcpkg-cmake-wrapper.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/postgresql)
file(INSTALL ${SOURCE_PATH}/COPYRIGHT DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
