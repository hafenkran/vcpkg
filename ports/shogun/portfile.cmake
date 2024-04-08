vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO shogun-toolbox/shogun
    REF ab274e7ab6bf24dd598c1daf1e626cb686d6e1cc
    SHA512 fb90e5bf802c6fd59bf35ab7bbde5e8cfcdc5d46c69c52097140b30c6b29e28b8341dd1ece7f8a1f9d9123f4bc06d44d288584ce7dfddccf3d33fe05106884ae
    HEAD_REF master
    PATCHES
        cmake.patch
        cmake-config.in.patch
        eigen-3.4.patch
        fix-dirent.patch
        fix-ASSERT-not-found.patch
        remove_cmake_flags.patch
        fix_accelerate_detection.patch
)

vcpkg_find_acquire_program(PYTHON3)
get_filename_component(PYTHON3_DIR "${PYTHON3}" DIRECTORY)
vcpkg_add_to_path("${PYTHON3_DIR}")

# Shogun only checks libraries for symbols and assumes everything is fine. 
# However openblas requires extra includes and mkl would require extra defines
# So get the needed flags via the pkg-config files.

x_vcpkg_pkgconfig_get_modules(PREFIX PC_BLAS_LAPACK MODULES lapack blas CFLAGS)

string(APPEND VCPKG_C_FLAGS_RELEASE " ${PC_BLAS_LAPACK_CFLAGS_RELEASE}")
string(APPEND VCPKG_CXX_FLAGS_RELEASE " ${PC_BLAS_LAPACK_CFLAGS_RELEASE}")

string(APPEND VCPKG_C_FLAGS_DEBUG " ${PC_BLAS_LAPACK_CFLAGS_DEBUG}")
string(APPEND VCPKG_CXX_FLAGS_DEBUG " ${PC_BLAS_LAPACK_CFLAGS_DEBUG}")

if(VCPKG_TARGET_IS_OSX)
  # Eigen3 and accelerate disagree on prototypes for lapack generating compiler errors
  set(extra_opts -DENABLE_EIGEN_LAPACK=OFF)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_META_EXAMPLES=OFF
        -DBUILD_EXAMPLES=OFF
        -DUSE_SVMLIGHT=OFF
        -DENABLE_TESTING=OFF
        -DLICENSE_GPL_SHOGUN=OFF
        -DLIBSHOGUN_BUILD_STATIC=ON
        -DCMAKE_DISABLE_FIND_PACKAGE_JSON=TRUE
        -DCMAKE_DISABLE_FIND_PACKAGE_ViennaCL=TRUE
        -DCMAKE_DISABLE_FIND_PACKAGE_TFLogger=TRUE
        -DCMAKE_DISABLE_FIND_PACKAGE_GLPK=TRUE
        -DCMAKE_DISABLE_FIND_PACKAGE_CPLEX=TRUE
        -DCMAKE_DISABLE_FIND_PACKAGE_ARPACK=TRUE
        -DCMAKE_DISABLE_FIND_PACKAGE_Mosek=TRUE
        -DCMAKE_DISABLE_FIND_PACKAGE_LpSolve=TRUE
        -DCMAKE_DISABLE_FIND_PACKAGE_ColPack=TRUE
        -DCMAKE_DISABLE_FIND_PACKAGE_ARPREC=TRUE
        -DCMAKE_DISABLE_FIND_PACKAGE_Ctags=TRUE
        -DCMAKE_DISABLE_FIND_PACKAGE_CCache=TRUE
        -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=TRUE
        -DCMAKE_DISABLE_FIND_PACKAGE_CURL=TRUE
        -DCMAKE_DISABLE_FIND_PACKAGE_OpenMP=TRUE
        -DINSTALL_TARGETS=shogun-static
        ${extra_opts}
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/shogun)

file(REMOVE_RECURSE
    # This directory is empty given the settings above
    "${CURRENT_PACKAGES_DIR}/include/shogun/mathematics/linalg/backend"
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

# Handle copyright
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
