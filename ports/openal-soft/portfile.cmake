vcpkg_fail_port_install(ON_TARGET "UWP")

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO kcat/openal-soft
    REF f5e0eef34db3a3ab94b61a2f99f84f078ba947e7 # openal-soft-1.20.1
    SHA512 3b05e67406e594215bc5a5e684feafa05ae3b6c898f5b91ab923c59688d7bc4f37f7a9f3bbc8ae252f8997d2588dc2766f44866eb095f0f53cb42030596d26a5
    HEAD_REF master
    PATCHES
        dont-export-symbols-in-static-build.patch
        fix-arm-builds.patch
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
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DLIBTYPE=${OPENAL_LIBTYPE}
        -DALSOFT_UTILS=OFF
        -DALSOFT_NO_CONFIG_UTIL=ON
        -DALSOFT_EXAMPLES=OFF
        -DALSOFT_TESTS=OFF
        -DALSOFT_CONFIG=OFF
        -DALSOFT_HRTF_DEFS=OFF
        -DALSOFT_AMBDEC_PRESETS=OFF
        -DALSOFT_BACKEND_ALSA=${ALSOFT_REQUIRE_LINUX}
        -DALSOFT_BACKEND_OSS=OFF
        -DALSOFT_BACKEND_SOLARIS=OFF
        -DALSOFT_BACKEND_SNDIO=OFF
        -DALSOFT_BACKEND_QSA=OFF
        -DALSOFT_BACKEND_PORTAUDIO=OFF
        -DALSOFT_BACKEND_PULSEAUDIO=OFF
        -DALSOFT_BACKEND_COREAUDIO=${ALSOFT_REQUIRE_OSX}
        -DALSOFT_BACKEND_JACK=OFF
        -DALSOFT_BACKEND_OPENSL=OFF
        -DALSOFT_BACKEND_WAVE=ON
        -DALSOFT_REQUIRE_WINMM=${ALSOFT_REQUIRE_WINDOWS}
        -DALSOFT_REQUIRE_DSOUND=${ALSOFT_REQUIRE_WINDOWS}
        -DALSOFT_REQUIRE_MMDEVAPI=${ALSOFT_REQUIRE_WINDOWS}
        -DALSOFT_CPUEXT_NEON=OFF
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/OpenAL)

foreach(HEADER al.h alc.h)
    file(READ ${CURRENT_PACKAGES_DIR}/include/AL/${HEADER} AL_H)
    if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
        string(REPLACE "defined(AL_LIBTYPE_STATIC)" "1" AL_H "${AL_H}")
    else()
        string(REPLACE "defined(AL_LIBTYPE_STATIC)" "0" AL_H "${AL_H}")
    endif()
    file(WRITE ${CURRENT_PACKAGES_DIR}/include/AL/${HEADER} "${AL_H}")
endforeach()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

vcpkg_copy_pdbs()
