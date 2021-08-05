vcpkg_fail_port_install(ON_TARGET "UWP")

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO kcat/openal-soft
    REF ae4eacf147e2c2340cc4e02a790df04c793ed0a9 # openal-soft-1.21.1
    SHA512 6ba006d3dad6efe002f285ff509a59f02b499ec3f6065df12a89c52355464117b4dbabcd04ee9cbf22cc3b4125c8e456769b172f8c3e9ee215e760b2c51a0a8f
    HEAD_REF master
    PATCHES
        dont-export-symbols-in-static-build.patch
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    set(OPENAL_LIBTYPE "SHARED")
else()
    set(OPENAL_LIBTYPE "STATIC")
endif()

set(ALSOFT_REQUIRE_LINUX OFF)
set(ALSOFT_REQUIRE_WINDOWS OFF)
set(ALSOFT_REQUIRE_OSX OFF)

if(VCPKG_TARGET_IS_LINUX)
    set(ALSOFT_REQUIRE_LINUX ON)
endif()
if(VCPKG_TARGET_IS_WINDOWS)
    set(ALSOFT_REQUIRE_WINDOWS ON)
endif()
if(VCPKG_TARGET_IS_OSX)
    set(ALSOFT_REQUIRE_OSX ON)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DLIBTYPE=${OPENAL_LIBTYPE}
        -DALSOFT_UTILS=OFF
        -DALSOFT_NO_CONFIG_UTIL=ON
        -DALSOFT_EXAMPLES=OFF
        -DALSOFT_CONFIG=OFF
        -DALSOFT_HRTF_DEFS=OFF
        -DALSOFT_AMBDEC_PRESETS=OFF
        -DALSOFT_BACKEND_ALSA=${ALSOFT_REQUIRE_LINUX}
        -DALSOFT_BACKEND_OSS=OFF
        -DALSOFT_BACKEND_SOLARIS=OFF
        -DALSOFT_BACKEND_SNDIO=OFF
        -DALSOFT_BACKEND_PORTAUDIO=OFF
        -DALSOFT_BACKEND_PULSEAUDIO=OFF
        -DALSOFT_BACKEND_COREAUDIO=${ALSOFT_REQUIRE_OSX}
        -DALSOFT_BACKEND_JACK=OFF
        -DALSOFT_BACKEND_OPENSL=OFF
        -DALSOFT_BACKEND_WAVE=ON
        -DALSOFT_BACKEND_WINMM=OFF
        -DALSOFT_BACKEND_DSOUND=OFF
        -DALSOFT_REQUIRE_WASAPI=${ALSOFT_REQUIRE_WINDOWS}
        -DALSOFT_CPUEXT_NEON=OFF
        -DCMAKE_DISABLE_FIND_PACKAGE_WindowsSDK=ON
    MAYBE_UNUSED_VARIABLES
        ALSOFT_AMBDEC_PRESETS
        ALSOFT_BACKEND_ALSA
        ALSOFT_BACKEND_COREAUDIO
        ALSOFT_BACKEND_JACK
        ALSOFT_BACKEND_OPENSL
        ALSOFT_BACKEND_OSS
        ALSOFT_BACKEND_PORTAUDIO
        ALSOFT_BACKEND_PULSEAUDIO
        ALSOFT_BACKEND_SNDIO
        ALSOFT_BACKEND_SOLARIS
        ALSOFT_CONFIG
        ALSOFT_CPUEXT_NEON
        ALSOFT_HRTF_DEFS
        CMAKE_DISABLE_FIND_PACKAGE_WindowsSDK
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH "lib/cmake/OpenAL")

foreach(HEADER al.h alc.h)
    file(READ "${CURRENT_PACKAGES_DIR}/include/AL/${HEADER}" AL_H)
    if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
        string(REPLACE "defined(AL_LIBTYPE_STATIC)" "1" AL_H "${AL_H}")
    else()
        string(REPLACE "defined(AL_LIBTYPE_STATIC)" "0" AL_H "${AL_H}")
    endif()
    file(WRITE "${CURRENT_PACKAGES_DIR}/include/AL/${HEADER}" "${AL_H}")
endforeach()

vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
file(COPY "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

vcpkg_copy_pdbs()
