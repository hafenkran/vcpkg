include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO cdcseacave/openMVS
    REF v0.9
    SHA512 a1081ee8562324137273846526c6570c77b35dba6a1a46df4e67f19cf7d0a1a4d4f6091b9444b66e0ca322f466b418ce4535d0c7ce10000df389cbe615f0c0b6
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/OpenMVS TARGET_PATH share/openmvs)

#somehow the native CMAKE_EXECUTABLE_SUFFIX does not work, so here we emulate it
if(CMAKE_HOST_WIN32)
set(EXECUTABLE_SUFFIX ".exe")
else()
set(EXECUTABLE_SUFFIX "")
endif()

if("all" IN_LIST FEATURES)
  file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/OpenMVS/DensifyPointCloud${EXECUTABLE_SUFFIX})
  file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/OpenMVS/InterfaceCOLMAP${EXECUTABLE_SUFFIX})
  file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/OpenMVS/InterfaceVisualSFM${EXECUTABLE_SUFFIX})
  file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/OpenMVS/ReconstructMesh${EXECUTABLE_SUFFIX})
  file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/OpenMVS/RefineMesh${EXECUTABLE_SUFFIX})
  file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/OpenMVS/TextureMesh${EXECUTABLE_SUFFIX})
  file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/openmvs/)
  if(EXISTS "${CURRENT_PACKAGES_DIR}/bin/OpenMVS/DensifyPointCloud${EXECUTABLE_SUFFIX}")
    file(RENAME ${CURRENT_PACKAGES_DIR}/bin/OpenMVS/DensifyPointCloud${EXECUTABLE_SUFFIX} ${CURRENT_PACKAGES_DIR}/tools/openmvs/DensifyPointCloud${EXECUTABLE_SUFFIX})
  endif()
  if(EXISTS "${CURRENT_PACKAGES_DIR}/bin/OpenMVS/InterfaceCOLMAP${EXECUTABLE_SUFFIX}")
    file(RENAME ${CURRENT_PACKAGES_DIR}/bin/OpenMVS/InterfaceCOLMAP${EXECUTABLE_SUFFIX} ${CURRENT_PACKAGES_DIR}/tools/openmvs/InterfaceCOLMAP${EXECUTABLE_SUFFIX})
  endif()
  if(EXISTS "${CURRENT_PACKAGES_DIR}/bin/OpenMVS/InterfaceVisualSFM${EXECUTABLE_SUFFIX}")
    file(RENAME ${CURRENT_PACKAGES_DIR}/bin/OpenMVS/InterfaceVisualSFM${EXECUTABLE_SUFFIX} ${CURRENT_PACKAGES_DIR}/tools/openmvs/InterfaceVisualSFM${EXECUTABLE_SUFFIX})
  endif()
  if(EXISTS "${CURRENT_PACKAGES_DIR}/bin/OpenMVS/ReconstructMesh${EXECUTABLE_SUFFIX}")
    file(RENAME ${CURRENT_PACKAGES_DIR}/bin/OpenMVS/ReconstructMesh${EXECUTABLE_SUFFIX} ${CURRENT_PACKAGES_DIR}/tools/openmvs/ReconstructMesh${EXECUTABLE_SUFFIX})
  endif()
  if(EXISTS "${CURRENT_PACKAGES_DIR}/bin/OpenMVS/RefineMesh${EXECUTABLE_SUFFIX}")
    file(RENAME ${CURRENT_PACKAGES_DIR}/bin/OpenMVS/RefineMesh${EXECUTABLE_SUFFIX} ${CURRENT_PACKAGES_DIR}/tools/openmvs/RefineMesh${EXECUTABLE_SUFFIX})
  endif()
  if(EXISTS "${CURRENT_PACKAGES_DIR}/bin/OpenMVS/TextureMesh${EXECUTABLE_SUFFIX}")
    file(RENAME ${CURRENT_PACKAGES_DIR}/bin/OpenMVS/TextureMesh${EXECUTABLE_SUFFIX} ${CURRENT_PACKAGES_DIR}/tools/openmvs/TextureMesh${EXECUTABLE_SUFFIX})
  endif()
  vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/openmvs)
endif()

if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
  file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/openmvs RENAME copyright)
