vcpkg_buildpath_length_warning(37)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    set(QT_OPENSSL_LINK_DEFAULT ON)
else()
    set(QT_OPENSSL_LINK_DEFAULT OFF)
endif()
option(QT_OPENSSL_LINK "Link against OpenSSL at compile-time." ${QT_OPENSSL_LINK_DEFAULT})

if (VCPKG_TARGET_IS_LINUX)
    message(WARNING "qt5-base currently requires some packages from the system package manager, see https://doc.qt.io/qt-5/linux-requirements.html")
    message(WARNING 
[[
qt5-base for qt5-x11extras requires several libraries from the system package manager. Please refer to
  https://github.com/microsoft/vcpkg/blob/master/scripts/azure-pipelines/linux/provision-image.sh
  for a complete list of them.
]]
    )
endif()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

if("latest" IN_LIST FEATURES) # latest = core currently
    set(QT_BUILD_LATEST ON)
    set(PATCHES
        patches/Qt5BasicConfig.patch
        patches/Qt5PluginTarget.patch
        patches/create_cmake.patch
        )
else()
    set(PATCHES
        patches/Qt5BasicConfig.patch
        patches/Qt5PluginTarget.patch
        patches/create_cmake.patch
    )
endif()

set(WITH_PGSQL_PLUGIN OFF)
if("postgresqlplugin" IN_LIST FEATURES)
    set(WITH_PGSQL_PLUGIN ON)
endif()

set(WITH_MYSQL_PLUGIN OFF)
if ("mysqlplugin" IN_LIST FEATURES)
    set(WITH_MYSQL_PLUGIN  ON)
endif()
if(WITH_MYSQL_PLUGIN AND NOT VCPKG_TARGET_IS_WINDOWS)
    message(WARNING "${PORT} is currently not setup to support feature 'mysqlplugin' on platforms other than windows. Feel free to open up a PR to fix it!")
endif()

include(qt_port_functions)
include(configure_qt)
include(install_qt)


#########################
## Find Host and Target mkspec name for configure
include(find_qt_mkspec)
find_qt_mkspec(TARGET_MKSPEC HOST_MKSPEC HOST_TOOLS)
set(QT_PLATFORM_CONFIGURE_OPTIONS TARGET_PLATFORM ${TARGET_MKSPEC})
if(DEFINED HOST_MKSPEC)
    list(APPEND QT_PLATFORM_CONFIGURE_OPTIONS HOST_PLATFORM ${HOST_MKSPEC})
endif()
if(DEFINED HOST_TOOLS)
    list(APPEND QT_PLATFORM_CONFIGURE_OPTIONS HOST_TOOLS_ROOT ${HOST_TOOLS})
endif()

#########################
## Downloading Qt5-Base

qt_download_submodule(  OUT_SOURCE_PATH SOURCE_PATH
                        PATCHES
                            patches/winmain_pro.patch          #Moves qtmain to manual-link
                            patches/windows_prf.patch          #fixes the qtmain dependency due to the above move
                            patches/qt_app.patch               #Moves the target location of qt5 host apps to always install into the host dir.
                            patches/gui_configure.patch        #Patches the gui configure.json to break freetype/fontconfig autodetection because it does not include its dependencies.
                            patches/icu.patch                  #Help configure find static icu builds in vcpkg on windows
                            patches/xlib.patch                 #Patches Xlib check to actually use Pkgconfig instead of makeSpec only
                            patches/egl.patch                  #Fix egl detection logic.
                            patches/zstdd.patch                #Fix detection of zstd in debug builds
                            patches/mysql_plugin_include.patch #Fix include path of mysql plugin
                            patches/mysql-configure.patch      #Fix mysql project
                            #patches/static_opengl.patch       #Use this patch if you really want to statically link angle on windows (e.g. using -opengl es2 and -static).
                                                               #Be carefull since it requires definining _GDI32_ for all dependent projects due to redefinition errors in the
                                                               #the windows supplied gl.h header and the angle gl.h otherwise.
                            #CMake fixes
                            ${PATCHES}
                            patches/Qt5GuiConfigExtras.patch # Patches the library search behavior for EGL since angle is not build with Qt
                    )

# Remove vendored dependencies to ensure they are not picked up by the build
foreach(DEPENDENCY zlib freetype harfbuzz-ng libjpeg libpng double-conversion sqlite pcre2)
    if(EXISTS ${SOURCE_PATH}/src/3rdparty/${DEPENDENCY})
        file(REMOVE_RECURSE ${SOURCE_PATH}/src/3rdparty/${DEPENDENCY})
    endif()
endforeach()
#file(REMOVE_RECURSE ${SOURCE_PATH}/include/QtZlib)

#########################
## Setup Configure options

# This fixes issues on machines with default codepages that are not ASCII compatible, such as some CJK encodings
set(ENV{_CL_} "/utf-8")

set(CORE_OPTIONS
    -confirm-license
    -opensource
    #-simulator_and_device
    #-ltcg
    #-combined-angle-lib
    # ENV ANGLE_DIR to external angle source dir. (Will always be compiled with Qt)
    #-optimized-tools
    #-force-debug-info
    -verbose
)

## 3rd Party Libs
list(APPEND CORE_OPTIONS
    -system-zlib
    -system-libjpeg
    -system-libpng
    -system-freetype
    -system-pcre
    -system-doubleconversion
    -system-sqlite
    -system-harfbuzz
    -icu
    -no-vulkan
    -no-angle # Qt does not need to build angle. VCPKG will build angle!
    -no-glib
    )

if(QT_OPENSSL_LINK)
    list(APPEND CORE_OPTIONS -openssl-linked)
endif()

if(WITH_PGSQL_PLUGIN)
    list(APPEND CORE_OPTIONS -sql-psql)
else()
    list(APPEND CORE_OPTIONS -no-sql-psql)
endif()
if(WITH_MYSQL_PLUGIN)
    list(APPEND CORE_OPTIONS -sql-mysql)
else()
    list(APPEND CORE_OPTIONS -no-sql-mysql)
endif()

if ("vulkan" IN_LIST FEATURES)
    list(APPEND CORE_OPTIONS --vulkan=yes)
else()
    list(APPEND CORE_OPTIONS --vulkan=no)
endif()

find_library(ZLIB_RELEASE NAMES z zlib PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH)
find_library(ZLIB_DEBUG NAMES z zlib zd zlibd PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)
find_library(JPEG_RELEASE NAMES jpeg jpeg-static PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH)
find_library(JPEG_DEBUG NAMES jpeg jpeg-static jpegd jpeg-staticd PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)
find_library(LIBPNG_RELEASE NAMES png16 libpng16 PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH) #Depends on zlib
find_library(LIBPNG_DEBUG NAMES png16 png16d libpng16 libpng16d PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)
find_library(PSQL_RELEASE NAMES pq libpq PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH) # Depends on openssl and zlib(linux)
find_library(PSQL_DEBUG NAMES pq libpq pqd libpqd PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)

if(NOT (PSQL_RELEASE MATCHES ".*\.so") AND NOT (PSQL_DEBUG MATCHES ".*\.so"))
    find_library(PSQL_COMMON_RELEASE NAMES pgcommon libpgcommon PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH) # Depends on openssl and zlib(linux)
    find_library(PSQL_COMMON_DEBUG NAMES pgcommon libpgcommon pgcommond libpgcommond PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)
    find_library(PSQL_PORT_RELEASE NAMES pgport libpgport PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH) # Depends on openssl and zlib(linux)
    find_library(PSQL_PORT_DEBUG NAMES pgport libpgport pgportd libpgportd PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)
endif()
find_library(MYSQL_RELEASE NAMES libmysql mysqlclient PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH) # Depends on openssl and zlib(linux)
find_library(MYSQL_DEBUG NAMES libmysql libmysqld mysqlclient mysqlclientd PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)

find_library(PCRE2_RELEASE NAMES pcre2-16 PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH)
find_library(PCRE2_DEBUG NAMES pcre2-16 pcre2-16d PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)
find_library(FREETYPE_RELEASE NAMES freetype PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH) #zlib, bzip2, libpng
find_library(FREETYPE_DEBUG NAMES freetype freetyped PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)
find_library(DOUBLECONVERSION_RELEASE NAMES double-conversion PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH)
find_library(DOUBLECONVERSION_DEBUG NAMES double-conversion PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)
find_library(HARFBUZZ_RELEASE NAMES harfbuzz PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH)
find_library(HARFBUZZ_DEBUG NAMES harfbuzz PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)
find_library(SQLITE_RELEASE NAMES sqlite3 PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH) # Depends on openssl and zlib(linux)
find_library(SQLITE_DEBUG NAMES sqlite3 sqlite3d PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)

find_library(BROTLI_COMMON_RELEASE NAMES brotlicommon brotlicommon-static PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH)
find_library(BROTLI_COMMON_DEBUG NAMES brotlicommon brotlicommon-static brotlicommond brotlicommon-staticd PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)
find_library(BROTLI_DEC_RELEASE NAMES brotlidec brotlidec-static PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH)
find_library(BROTLI_DEC_DEBUG NAMES brotlidec brotlidec-static brotlidecd brotlidec-staticd PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)

find_library(ICUUC_RELEASE NAMES icuuc libicuuc PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH)
find_library(ICUUC_DEBUG NAMES icuucd libicuucd icuuc libicuuc PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)
find_library(ICUTU_RELEASE NAMES icutu libicutu PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH)
find_library(ICUTU_DEBUG NAMES icutud libicutud icutu libicutu PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)

# Was installed in WSL but not on CI machine
#    find_library(ICULX_RELEASE NAMES iculx libiculx PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH)
#    find_library(ICULX_DEBUG NAMES iculxd libiculxd iculx libiculx PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)

find_library(ICUIO_RELEASE NAMES icuio libicuio PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH)
find_library(ICUIO_DEBUG NAMES icuiod libicuiod icuio libicuio PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)
find_library(ICUIN_RELEASE NAMES icui18n libicui18n icuin PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH)
find_library(ICUIN_DEBUG NAMES icui18nd libicui18nd icui18n libicui18n icuin icuind PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)
find_library(ICUDATA_RELEASE NAMES icudata libicudata icudt PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH)
find_library(ICUDATA_DEBUG NAMES icudatad libicudatad icudata libicudata icudtd PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)
set(ICU_RELEASE "${ICUIN_RELEASE} ${ICUTU_RELEASE} ${ICULX_RELEASE} ${ICUUC_RELEASE} ${ICUIO_RELEASE} ${ICUDATA_RELEASE}")
set(ICU_DEBUG "${ICUIN_DEBUG} ${ICUTU_DEBUG} ${ICULX_DEBUG} ${ICUUC_DEBUG} ${ICUIO_DEBUG} ${ICUDATA_DEBUG}")
if(VCPKG_TARGET_IS_WINDOWS)
    set(ICU_RELEASE "${ICU_RELEASE} Advapi32.lib")
    set(ICU_DEBUG "${ICU_DEBUG} Advapi32.lib" )
endif()

find_library(FONTCONFIG_RELEASE NAMES fontconfig PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH)
find_library(FONTCONFIG_DEBUG NAMES fontconfig PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)
find_library(EXPAT_RELEASE NAMES expat PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH)
find_library(EXPAT_DEBUG NAMES expat PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)

#Dependent libraries
find_library(ZSTD_RELEASE NAMES zstd zstd_static PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH)
find_library(ZSTD_DEBUG NAMES zstdd zstd_staticd PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)
find_library(BZ2_RELEASE bz2 PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH)
find_library(BZ2_DEBUG bz2 bz2d PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)
find_library(SSL_RELEASE ssl ssleay32 PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH)
find_library(SSL_DEBUG ssl ssleay32 ssld ssleay32d PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)
find_library(EAY_RELEASE libeay32 crypto libcrypto PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH)
find_library(EAY_DEBUG libeay32 crypto libcrypto libeay32d cryptod libcryptod PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)

set(FREETYPE_RELEASE_ALL "${FREETYPE_RELEASE} ${BZ2_RELEASE} ${LIBPNG_RELEASE} ${ZLIB_RELEASE} ${BROTLI_DEC_RELEASE} ${BROTLI_COMMON_RELEASE}")
set(FREETYPE_DEBUG_ALL "${FREETYPE_DEBUG} ${BZ2_DEBUG} ${LIBPNG_DEBUG} ${ZLIB_DEBUG} ${BROTLI_DEC_DEBUG} ${BROTLI_COMMON_DEBUG}")

# If HarfBuzz is built with GLib enabled, it must be statically link
x_vcpkg_pkgconfig_get_modules(PREFIX harfbuzz MODULES harfbuzz LIBRARIES)

set(RELEASE_OPTIONS
            "LIBJPEG_LIBS=${JPEG_RELEASE}"
            "ZLIB_LIBS=${ZLIB_RELEASE}"
            "LIBPNG_LIBS=${LIBPNG_RELEASE} ${ZLIB_RELEASE}"
            "PCRE2_LIBS=${PCRE2_RELEASE}"
            "FREETYPE_LIBS=${FREETYPE_RELEASE_ALL}"
            "ICU_LIBS=${ICU_RELEASE}"
            "QMAKE_LIBS_PRIVATE+=${BZ2_RELEASE}"
            "QMAKE_LIBS_PRIVATE+=${LIBPNG_RELEASE}"
            "QMAKE_LIBS_PRIVATE+=${ICU_RELEASE}"
            "QMAKE_LIBS_PRIVATE+=${ZSTD_RELEASE}"
            )
set(DEBUG_OPTIONS
            "LIBJPEG_LIBS=${JPEG_DEBUG}"
            "ZLIB_LIBS=${ZLIB_DEBUG}"
            "LIBPNG_LIBS=${LIBPNG_DEBUG} ${ZLIB_DEBUG}"
            "PCRE2_LIBS=${PCRE2_DEBUG}"
            "FREETYPE_LIBS=${FREETYPE_DEBUG_ALL}"
            "ICU_LIBS=${ICU_DEBUG}"
            "QMAKE_LIBS_PRIVATE+=${BZ2_DEBUG}"
            "QMAKE_LIBS_PRIVATE+=${LIBPNG_DEBUG}"
            "QMAKE_LIBS_PRIVATE+=${ICU_DEBUG}"
            "QMAKE_LIBS_PRIVATE+=${ZSTD_DEBUG}"
            )

if(VCPKG_TARGET_IS_WINDOWS)
    if(VCPKG_TARGET_IS_UWP)
        list(APPEND CORE_OPTIONS -appstore-compliant)
    endif()
    if(NOT ${VCPKG_LIBRARY_LINKAGE} STREQUAL "static")
        list(APPEND CORE_OPTIONS -opengl dynamic) # other options are "-no-opengl", "-opengl angle", and "-opengl desktop" and "-opengel es2"
    else()
        list(APPEND CORE_OPTIONS -opengl dynamic) # other possible option without moving angle dlls: "-opengl desktop". "-opengel es2" only works with commented patch
    endif()
    list(APPEND RELEASE_OPTIONS
            "SQLITE_LIBS=${SQLITE_RELEASE}"
            "HARFBUZZ_LIBS=${harfbuzz_LIBRARIES_RELEASE}"
            "OPENSSL_LIBS=${SSL_RELEASE} ${EAY_RELEASE} ws2_32.lib secur32.lib advapi32.lib shell32.lib crypt32.lib user32.lib gdi32.lib"
        )

    list(APPEND DEBUG_OPTIONS
            "SQLITE_LIBS=${SQLITE_DEBUG}"
            "HARFBUZZ_LIBS=${harfbuzz_LIBRARIES_DEBUG}"
            "OPENSSL_LIBS=${SSL_DEBUG} ${EAY_DEBUG} ws2_32.lib secur32.lib advapi32.lib shell32.lib crypt32.lib user32.lib gdi32.lib"
        )
    if(WITH_PGSQL_PLUGIN)
        list(APPEND RELEASE_OPTIONS "PSQL_LIBS=${PSQL_RELEASE} ${PSQL_PORT_RELEASE} ${PSQL_COMMON_RELEASE} ${SSL_RELEASE} ${EAY_RELEASE} ws2_32.lib secur32.lib advapi32.lib shell32.lib crypt32.lib user32.lib gdi32.lib")
        list(APPEND DEBUG_OPTIONS "PSQL_LIBS=${PSQL_DEBUG} ${PSQL_PORT_DEBUG} ${PSQL_COMMON_DEBUG} ${SSL_DEBUG} ${EAY_DEBUG} ws2_32.lib secur32.lib advapi32.lib shell32.lib crypt32.lib user32.lib gdi32.lib")
    endif()
    if (WITH_MYSQL_PLUGIN)
        list(APPEND RELEASE_OPTIONS "MYSQL_LIBS=${MYSQL_RELEASE}")
        list(APPEND DEBUG_OPTIONS "MYSQL_LIBS=${MYSQL_DEBUG}")
    endif(WITH_MYSQL_PLUGIN)

elseif(VCPKG_TARGET_IS_LINUX)
    list(APPEND CORE_OPTIONS -fontconfig -xcb-xlib -xcb -linuxfb)
    if (NOT EXISTS "/usr/include/GL/glu.h")
        message(FATAL_ERROR "qt5 requires libgl1-mesa-dev and libglu1-mesa-dev, please use your distribution's package manager to install them.\nExample: \"apt-get install libgl1-mesa-dev libglu1-mesa-dev\"")
    endif()
    list(APPEND RELEASE_OPTIONS
            "SQLITE_LIBS=${SQLITE_RELEASE} -ldl -lpthread"
            "HARFBUZZ_LIBS=${harfbuzz_LIBRARIES_RELEASE}"
            "OPENSSL_LIBS=${SSL_RELEASE} ${EAY_RELEASE} -ldl -lpthread"
            "FONTCONFIG_LIBS=${FONTCONFIG_RELEASE} ${FREETYPE_RELEASE} ${EXPAT_RELEASE} -luuid"
        )
    list(APPEND DEBUG_OPTIONS
            "SQLITE_LIBS=${SQLITE_DEBUG} -ldl -lpthread"
            "HARFBUZZ_LIBS=${harfbuzz_LIBRARIES_DEBUG}"
            "OPENSSL_LIBS=${SSL_DEBUG} ${EAY_DEBUG} -ldl -lpthread"
            "FONTCONFIG_LIBS=${FONTCONFIG_DEBUG} ${FREETYPE_DEBUG} ${EXPAT_DEBUG} -luuid"
        )
    if(WITH_PGSQL_PLUGIN)
        list(APPEND RELEASE_OPTIONS "PSQL_LIBS=${PSQL_RELEASE} ${PSQL_PORT_RELEASE} ${PSQL_TYPES_RELEASE} ${PSQL_COMMON_RELEASE} ${SSL_RELEASE} ${EAY_RELEASE} -ldl -lpthread")
        list(APPEND DEBUG_OPTIONS "PSQL_LIBS=${PSQL_DEBUG} ${PSQL_PORT_DEBUG} ${PSQL_TYPES_DEBUG} ${PSQL_COMMON_DEBUG} ${SSL_DEBUG} ${EAY_DEBUG} -ldl -lpthread")
    endif()
elseif(VCPKG_TARGET_IS_OSX)
    list(APPEND CORE_OPTIONS -fontconfig)
    if(DEFINED VCPKG_OSX_DEPLOYMENT_TARGET)
        set(ENV{QMAKE_MACOSX_DEPLOYMENT_TARGET} ${VCPKG_OSX_DEPLOYMENT_TARGET})
    else()
        execute_process(COMMAND xcrun --show-sdk-version
                            OUTPUT_FILE OSX_SDK_VER.txt
                            WORKING_DIRECTORY ${CURRENT_BUILDTREES_DIR})
        FILE(STRINGS "${CURRENT_BUILDTREES_DIR}/OSX_SDK_VER.txt" VCPKG_OSX_DEPLOYMENT_TARGET REGEX "^[0-9][0-9]\.[0-9][0-9]*")
        message(STATUS "Detected OSX SDK Version: ${VCPKG_OSX_DEPLOYMENT_TARGET}")
        string(REGEX MATCH "^[0-9][0-9]\.[0-9][0-9]*" VCPKG_OSX_DEPLOYMENT_TARGET ${VCPKG_OSX_DEPLOYMENT_TARGET})
        message(STATUS "Major.Minor OSX SDK Version: ${VCPKG_OSX_DEPLOYMENT_TARGET}")
        set(ENV{QMAKE_MACOSX_DEPLOYMENT_TARGET} ${VCPKG_OSX_DEPLOYMENT_TARGET})
        if(${VCPKG_OSX_DEPLOYMENT_TARGET} GREATER "10.15") # Max Version supported by QT. This version is defined in mkspecs/common/macx.conf as QT_MAC_SDK_VERSION_MAX
            message(STATUS "Qt ${QT_MAJOR_MINOR_VER}.${QT_PATCH_VER} only support OSX_DEPLOYMENT_TARGET up to 10.15")
            set(VCPKG_OSX_DEPLOYMENT_TARGET "10.15")
        endif()
        set(ENV{QMAKE_MACOSX_DEPLOYMENT_TARGET} ${VCPKG_OSX_DEPLOYMENT_TARGET})
        message(STATUS "Enviromnent OSX SDK Version: $ENV{QMAKE_MACOSX_DEPLOYMENT_TARGET}")
        FILE(READ "${SOURCE_PATH}/mkspecs/common/macx.conf" _tmp_contents)
        string(REPLACE "QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.13" "QMAKE_MACOSX_DEPLOYMENT_TARGET = ${VCPKG_OSX_DEPLOYMENT_TARGET}" _tmp_contents ${_tmp_contents})
        FILE(WRITE "${SOURCE_PATH}/mkspecs/common/macx.conf" ${_tmp_contents})
    endif()
    #list(APPEND QT_PLATFORM_CONFIGURE_OPTIONS HOST_PLATFORM ${TARGET_MKSPEC})
    list(APPEND RELEASE_OPTIONS
            "SQLITE_LIBS=${SQLITE_RELEASE} -ldl -lpthread"
            "HARFBUZZ_LIBS=${harfbuzz_LIBRARIES_RELEASE} -framework ApplicationServices"
            "OPENSSL_LIBS=${SSL_RELEASE} ${EAY_RELEASE} -ldl -lpthread"
            "FONTCONFIG_LIBS=${FONTCONFIG_RELEASE} ${FREETYPE_RELEASE} ${EXPAT_RELEASE} -liconv"
        )
    list(APPEND DEBUG_OPTIONS
            "SQLITE_LIBS=${SQLITE_DEBUG} -ldl -lpthread"
            "HARFBUZZ_LIBS=${harfbuzz_LIBRARIES_DEBUG} -framework ApplicationServices"
            "OPENSSL_LIBS=${SSL_DEBUG} ${EAY_DEBUG} -ldl -lpthread"
            "FONTCONFIG_LIBS=${FONTCONFIG_DEBUG} ${FREETYPE_DEBUG} ${EXPAT_DEBUG} -liconv"
        )

    if(WITH_PGSQL_PLUGIN)
        list(APPEND RELEASE_OPTIONS "PSQL_LIBS=${PSQL_RELEASE} ${PSQL_PORT_RELEASE} ${PSQL_TYPES_RELEASE} ${PSQL_COMMON_RELEASE} ${SSL_RELEASE} ${EAY_RELEASE} -ldl -lpthread")
        list(APPEND DEBUG_OPTIONS "PSQL_LIBS=${PSQL_DEBUG} ${PSQL_PORT_DEBUG} ${PSQL_TYPES_DEBUG} ${PSQL_COMMON_DEBUG} ${SSL_DEBUG} ${EAY_DEBUG} -ldl -lpthread")
    endif()
endif()

## Do not build tests or examples
list(APPEND CORE_OPTIONS
    -nomake examples
    -nomake tests)

if(QT_UPDATE_VERSION)
    SET(VCPKG_POLICY_EMPTY_PACKAGE enabled)
else()
    configure_qt(
        SOURCE_PATH ${SOURCE_PATH}
        ${QT_PLATFORM_CONFIGURE_OPTIONS}
        OPTIONS ${CORE_OPTIONS}
        OPTIONS_RELEASE ${RELEASE_OPTIONS}
        OPTIONS_DEBUG ${DEBUG_OPTIONS}
        )
    install_qt()

    #########################
    #TODO: Make this a function since it is also done by modular scripts!
    # e.g. by patching mkspecs/features/qt_tools.prf somehow
    file(GLOB_RECURSE PRL_FILES "${CURRENT_PACKAGES_DIR}/lib/*.prl" "${CURRENT_PACKAGES_DIR}/tools/qt5/lib/*.prl" "${CURRENT_PACKAGES_DIR}/tools/qt5/mkspecs/*.pri"
                                "${CURRENT_PACKAGES_DIR}/debug/lib/*.prl" "${CURRENT_PACKAGES_DIR}/tools/qt5/debug/lib/*.prl" "${CURRENT_PACKAGES_DIR}/tools/qt5/debug/mkspecs/*.pri")

    file(TO_CMAKE_PATH "${CURRENT_INSTALLED_DIR}/include" CMAKE_INCLUDE_PATH)

    if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
        qt_fix_prl("${CURRENT_INSTALLED_DIR}" "${PRL_FILES}")
        file(COPY ${CMAKE_CURRENT_LIST_DIR}/qtdeploy.ps1 DESTINATION ${CURRENT_PACKAGES_DIR}/plugins)
    endif()

    if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
        qt_fix_prl("${CURRENT_INSTALLED_DIR}/debug" "${PRL_FILES}")
        file(COPY ${CMAKE_CURRENT_LIST_DIR}/qtdeploy.ps1 DESTINATION ${CURRENT_PACKAGES_DIR}/debug/plugins)
    endif()

    file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/share)
    file(RENAME ${CURRENT_PACKAGES_DIR}/lib/cmake ${CURRENT_PACKAGES_DIR}/share/cmake)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/cmake) # TODO: check if important debug information for cmake is lost

    #This needs a new VCPKG policy or a static angle build (ANGLE needs to be fixed in VCPKG!)
    if(VCPKG_TARGET_IS_WINDOWS AND ${VCPKG_LIBRARY_LINKAGE} MATCHES "static") # Move angle dll libraries
        if(EXISTS "${CURRENT_PACKAGES_DIR}/bin")
            message(STATUS "Moving ANGLE dlls from /bin to /tools/qt5-angle/bin. In static builds dlls are not allowed in /bin")
            file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/qt5-angle)
            file(RENAME ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/tools/qt5-angle/bin)
            if(EXISTS ${CURRENT_PACKAGES_DIR}/debug/bin)
                file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/qt5-angle/debug)
                file(RENAME ${CURRENT_PACKAGES_DIR}/debug/bin ${CURRENT_PACKAGES_DIR}/tools/qt5-angle/debug/bin)
            endif()
        endif()
    endif()

    ## Fix location of qtmain(d).lib. Has been moved into manual-link. Add debug version
    set(cmakefile "${CURRENT_PACKAGES_DIR}/share/cmake/Qt5Core/Qt5CoreConfigExtras.cmake")
    file(READ "${cmakefile}" _contents)
    if(VCPKG_TARGET_IS_WINDOWS AND NOT VCPKG_BUILD_TYPE)
        string(REPLACE "set_property(TARGET Qt5::WinMain APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)" "set_property(TARGET Qt5::WinMain APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE DEBUG)" _contents "${_contents}")
        string(REPLACE
        [[set(imported_location "${_qt5Core_install_prefix}/lib/qtmain.lib")]]
        [[set(imported_location_release "${_qt5Core_install_prefix}/lib/manual-link/qtmain.lib")
          set(imported_location_debug "${_qt5Core_install_prefix}/debug/lib/manual-link/qtmaind.lib")]]
          _contents "${_contents}")
        string(REPLACE
[[    set_target_properties(Qt5::WinMain PROPERTIES
        IMPORTED_LOCATION_RELEASE ${imported_location}
    )]]
[[    set_target_properties(Qt5::WinMain PROPERTIES
        IMPORTED_LOCATION_RELEASE ${imported_location_release}
        IMPORTED_LOCATION_DEBUG ${imported_location_debug}
    )]]
    _contents "${_contents}")
    else() # Single configuration build (either debug or release)
        # Release case
        string(REPLACE
            [[set(imported_location "${_qt5Core_install_prefix}/lib/qtmain.lib")]]
            [[set(imported_location "${_qt5Core_install_prefix}/lib/manual-link/qtmain.lib")]]
            _contents "${_contents}")
        # Debug case (whichever will match)
        string(REPLACE
            [[set(imported_location "${_qt5Core_install_prefix}/lib/qtmaind.lib")]]
            [[set(imported_location "${_qt5Core_install_prefix}/debug/lib/manual-link/qtmaind.lib")]]
            _contents "${_contents}")
        string(REPLACE
            [[set(imported_location "${_qt5Core_install_prefix}/debug/lib/qtmaind.lib")]]
            [[set(imported_location "${_qt5Core_install_prefix}/debug/lib/manual-link/qtmaind.lib")]]
            _contents "${_contents}")
    endif()
    file(WRITE "${cmakefile}" "${_contents}")

    if(EXISTS ${CURRENT_PACKAGES_DIR}/tools/qt5/bin)
        file(COPY ${CURRENT_PACKAGES_DIR}/tools/qt5/bin DESTINATION ${CURRENT_PACKAGES_DIR}/tools/${PORT})
        vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin)
        vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/qt5/bin)
    endif()
    # This should be removed if possible! (Currently debug build of qt5-translations requires it.)
    if(EXISTS ${CURRENT_PACKAGES_DIR}/debug/tools/qt5/bin)
        file(COPY ${CURRENT_PACKAGES_DIR}/tools/qt5/bin DESTINATION ${CURRENT_PACKAGES_DIR}/tools/qt5/debug)
        vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/qt5/debug/bin)
    endif()

    if(EXISTS ${CURRENT_PACKAGES_DIR}/tools/qt5/bin/qt.conf)
        file(REMOVE "${CURRENT_PACKAGES_DIR}/tools/qt5/bin/qt.conf")
    endif()
    set(CURRENT_INSTALLED_DIR_BACKUP "${CURRENT_INSTALLED_DIR}")
    set(CURRENT_INSTALLED_DIR "./../../.." ) # Making the qt.conf relative and not absolute
    configure_file(${CURRENT_PACKAGES_DIR}/tools/qt5/qt_release.conf ${CURRENT_PACKAGES_DIR}/tools/qt5/bin/qt.conf) # This makes the tools at least useable for release
    set(CURRENT_INSTALLED_DIR "${CURRENT_INSTALLED_DIR_BACKUP}")

    qt_install_copyright(${SOURCE_PATH})
endif()
#install scripts for other qt ports
file(COPY
    ${CMAKE_CURRENT_LIST_DIR}/cmake/qt_port_hashes.cmake
    ${CMAKE_CURRENT_LIST_DIR}/cmake/qt_port_functions.cmake
    ${CMAKE_CURRENT_LIST_DIR}/cmake/qt_fix_makefile_install.cmake
    ${CMAKE_CURRENT_LIST_DIR}/cmake/qt_fix_cmake.cmake
    ${CMAKE_CURRENT_LIST_DIR}/cmake/qt_fix_prl.cmake
    ${CMAKE_CURRENT_LIST_DIR}/cmake/qt_download_submodule.cmake
    ${CMAKE_CURRENT_LIST_DIR}/cmake/qt_build_submodule.cmake
    ${CMAKE_CURRENT_LIST_DIR}/cmake/qt_install_copyright.cmake
    ${CMAKE_CURRENT_LIST_DIR}/cmake/qt_submodule_installation.cmake
    DESTINATION
        ${CURRENT_PACKAGES_DIR}/share/qt5
)

# Fix Qt5GuiConfigExtras EGL path
if(VCPKG_TARGET_IS_LINUX)
    set(_file "${CURRENT_PACKAGES_DIR}/share/cmake/Qt5Gui/Qt5GuiConfigExtras.cmake")
    file(READ "${_file}" _contents)
    string(REGEX REPLACE "_qt5gui_find_extra_libs\\\(EGL[^\\\n]+" "_qt5gui_find_extra_libs(EGL \"EGL\" \"\" \"\${_qt5Gui_install_prefix}/include\")\n" _contents "${_contents}")
    file(WRITE "${_file}" "${_contents}")
endif()

if(QT_BUILD_LATEST)
    file(COPY
        ${CMAKE_CURRENT_LIST_DIR}/cmake/qt_port_hashes_latest.cmake
        DESTINATION
            ${CURRENT_PACKAGES_DIR}/share/qt5
    )
endif()

# #Code to get generated CMake files from CI
# file(RENAME "${CURRENT_PACKAGES_DIR}/share/cmake/Qt5Core/Qt5CoreConfig.cmake" "${CURRENT_BUILDTREES_DIR}/Qt5CoreConfig.cmake.log")
# file(GLOB_RECURSE CMAKE_GUI_FILES "${CURRENT_PACKAGES_DIR}/share/cmake/Qt5Gui/*.cmake" )
# foreach(cmake_file ${CMAKE_GUI_FILES})
    # get_filename_component(cmake_filename "${cmake_file}" NAME)
    # file(COPY "${cmake_file}" DESTINATION "${CURRENT_BUILDTREES_DIR}")
    # file(RENAME "${CURRENT_BUILDTREES_DIR}/${cmake_filename}" "${CURRENT_BUILDTREES_DIR}/${cmake_filename}.log")
# endforeach()
# #Copy config.log from buildtree/triplet to buildtree to get the log in CI in case of failure
# if(EXISTS "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/config.log")
    # file(RENAME "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/config.log" "${CURRENT_BUILDTREES_DIR}/config-rel.log")
# endif()
# if(EXISTS "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/config.log")
    # file(RENAME "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/config.log" "${CURRENT_BUILDTREES_DIR}/config-dbg.log")
# endif()
# message(FATAL_ERROR "Need Info from CI!")
