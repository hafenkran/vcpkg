include(vcpkg_common_functions)



set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/tests)
vcpkg_from_github(ARCHIVE
  OUT_SOURCE_PATH SOURCE_PATH
  REPO Bromeon/Thor
  REF v2.0
  SHA512 634fa5286405d9a8a837c082ace98bbb02e609521418935855b9e2fcad57003dbe35088bd771cf6a9292e55d3787f7e463d7a4cca0d0f007509de2520d9a8cf9
  HEAD_REF master
)


set(ENV{SFML_ROOT} ${CURRENT_INSTALLED_DIR})

if(VCPKG_CRT_LINKAGE STREQUAL static)
  set(THOR_STATIC_STD_LIBS  ON)
else()
  set(THOR_STATIC_STD_LIBS  OFF)
endif()


if(VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
  set(THOR_SHARED_LIBS ON)
else()
  set(THOR_SHARED_LIBS OFF)
endif()

vcpkg_configure_cmake(
  SOURCE_PATH ${SOURCE_PATH}
  PREFER_NINJA
  OPTIONS
  -DTHOR_SHARED_LIBS=${THOR_SHARED_LIBS}
  -DTHOR_STATIC_STD_LIBS=${THOR_STATIC_STD_LIBS}
)

vcpkg_install_cmake()


set(CONFIG_FILE "${CURRENT_PACKAGES_DIR}/include/Thor/Config.hpp")

file(READ ${CONFIG_FILE} CONFIG_H)
   if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
       string(REPLACE "defined(SFML_STATIC)" "1" CONFIG_H "${CONFIG_H}")
   else()
       string(REPLACE "defined(SFML_STATIC)" "0" CONFIG_H "${CONFIG_H}")
   endif()

file(WRITE ${CONFIG_FILE} "${CONFIG_H}")

file(GLOB LICENSE
  "${CURRENT_PACKAGES_DIR}/debug/LicenseThor.txt"
  "${CURRENT_PACKAGES_DIR}/debug/LicenseAurora.txt"
  "${CURRENT_PACKAGES_DIR}/LicenseThor.txt"
  "${CURRENT_PACKAGES_DIR}/LicenseAurora.txt"
)

if(LICENSE)
  file(REMOVE ${LICENSE})
endif()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/Aurora)

file(INSTALL ${SOURCE_PATH}/License.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/thor RENAME copyright)

vcpkg_copy_pdbs()
