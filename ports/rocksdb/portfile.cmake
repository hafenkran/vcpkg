include(vcpkg_common_functions)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO facebook/rocksdb
  REF rocksdb-5.11.3
  SHA512 a4c771e36056ee0da497202b25092d89799db43573a442568b4392b8478ac20320dabf4c904e93bd0641a32f249e9c8dcad0d67577acaee6902cd4d30f29ce57
  HEAD_REF master
)

vcpkg_apply_patches(
  SOURCE_PATH ${SOURCE_PATH}
  PATCHES
    "${CMAKE_CURRENT_LIST_DIR}/0002-disable-gtest.patch"
    "${CMAKE_CURRENT_LIST_DIR}/0003-only-build-one-flavor.patch"
    "${CMAKE_CURRENT_LIST_DIR}/use-find-package.patch"
)

file(REMOVE "${SOURCE_PATH}/cmake/modules/Findzlib.cmake")
file(COPY
  "${CMAKE_CURRENT_LIST_DIR}/Findlz4.cmake"
  "${CMAKE_CURRENT_LIST_DIR}/Findsnappy.cmake"
  DESTINATION "${SOURCE_PATH}/cmake/modules"
)

if(VCPKG_CRT_LINKAGE STREQUAL "static")
  set(WITH_MD_LIBRARY OFF)
else()
  set(WITH_MD_LIBRARY ON)
endif()

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" ROCKSDB_DISABLE_INSTALL_SHARED_LIB)
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" ROCKSDB_DISABLE_INSTALL_STATIC_LIB)

set(WITH_LZ4 OFF)
if("lz4" IN_LIST FEATURES)
  set(WITH_LZ4 ON)
endif()

set(WITH_SNAPPY OFF)
if("snappy" IN_LIST FEATURES)
  set(WITH_SNAPPY ON)
endif()

set(WITH_ZLIB OFF)
if("zlib" IN_LIST FEATURES)
  set(WITH_ZLIB ON)
endif()

get_filename_component(ROCKSDB_VERSION "${SOURCE_PATH}" NAME)
string(REPLACE "rocksdb-rocksdb-" "" ROCKSDB_VERSION "${ROCKSDB_VERSION}")

vcpkg_configure_cmake(
  SOURCE_PATH ${SOURCE_PATH}
  PREFER_NINJA
  OPTIONS
  -DWITH_GFLAGS=0
  -DWITH_SNAPPY=${WITH_SNAPPY}
  -DWITH_LZ4=${WITH_LZ4}
  -DWITH_ZLIB=${WITH_ZLIB}
  -DWITH_TESTS=OFF
  -DROCKSDB_INSTALL_ON_WINDOWS=ON
  -DFAIL_ON_WARNINGS=OFF
  -DWITH_MD_LIBRARY=${WITH_MD_LIBRARY}
  -DPORTABLE=ON
  -DCMAKE_DEBUG_POSTFIX=d
  -DROCKSDB_DISABLE_INSTALL_SHARED_LIB=${ROCKSDB_DISABLE_INSTALL_SHARED_LIB}
  -DROCKSDB_DISABLE_INSTALL_STATIC_LIB=${ROCKSDB_DISABLE_INSTALL_STATIC_LIB}
  -DROCKSDB_VERSION=${ROCKSDB_VERSION}
  -DCURRENT_INSTALLED_DIR=${CURRENT_INSTALLED_DIR}
  -DCMAKE_DISABLE_FIND_PACKAGE_TBB=TRUE
  -DCMAKE_DISABLE_FIND_PACKAGE_NUMA=TRUE
  -DCMAKE_DISABLE_FIND_PACKAGE_gtest=TRUE
  -DCMAKE_DISABLE_FIND_PACKAGE_Git=TRUE
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/rocksdb)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

file(INSTALL ${SOURCE_PATH}/LICENSE.Apache DESTINATION ${CURRENT_PACKAGES_DIR}/share/rocksdb RENAME copyright)
file(INSTALL ${SOURCE_PATH}/LICENSE.leveldb DESTINATION ${CURRENT_PACKAGES_DIR}/share/rocksdb)

vcpkg_copy_pdbs()
