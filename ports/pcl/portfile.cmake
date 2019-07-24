include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO PointCloudLibrary/pcl
    REF pcl-1.9.1
    SHA512 ca95028c23861ac2df0fa7e18fdd0202255cb2e49ab714325eb36c35289442c6eedbf489e6f9f232b30fa2a93eff4c9619f8a14d3fdfe58f353a4a6e26206bdf
    HEAD_REF master
    PATCHES
        pcl_utils.patch
        pcl_config.patch
        use_flann_targets.patch
        boost-1.70.patch
        cuda_10_1.patch
)

file(REMOVE ${SOURCE_PATH}/cmake/Modules/FindFLANN.cmake)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" PCL_SHARED_LIBS)

set(WITH_OPENNI2 OFF)
if("openni2" IN_LIST FEATURES)
    set(WITH_OPENNI2 ON)
endif()

set(WITH_QT OFF)
if("qt" IN_LIST FEATURES)
    set(WITH_QT ON)
endif()

set(WITH_PCAP OFF)
if("pcap" IN_LIST FEATURES)
    set(WITH_PCAP ON)
endif()

set(WITH_CUDA OFF)
if("cuda" IN_LIST FEATURES)
    set(WITH_CUDA ON)
endif()

set(BUILD_TOOLS OFF)
if("tools" IN_LIST FEATURES)
    set(BUILD_TOOLS ON)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        # BUILD
        -DBUILD_surface_on_nurbs=ON
        -DBUILD_tools=${BUILD_TOOLS}
        -DBUILD_CUDA=${WITH_CUDA}
        -DBUILD_GPU=${WITH_CUDA} # build GPU when use CUDA
        # PCL
        -DPCL_BUILD_WITH_BOOST_DYNAMIC_LINKING_WIN32=${PCL_SHARED_LIBS}
        -DPCL_BUILD_WITH_FLANN_DYNAMIC_LINKING_WIN32=${PCL_SHARED_LIBS}
        -DPCL_BUILD_WITH_QHULL_DYNAMIC_LINKING_WIN32=${PCL_SHARED_LIBS}
        -DPCL_SHARED_LIBS=${PCL_SHARED_LIBS}
        # WITH
        -DWITH_CUDA=${WITH_CUDA}
        -DWITH_LIBUSB=OFF
        -DWITH_OPENNI2=${WITH_OPENNI2}
        -DWITH_PCAP=${WITH_PCAP}
        -DWITH_PNG=ON
        -DWITH_QHULL=ON
        -DWITH_QT=${WITH_QT}
        -DWITH_VTK=ON
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

if(BUILD_TOOLS)
    file(GLOB EXEFILES_RELEASE ${CURRENT_PACKAGES_DIR}/bin/*.exe)
    file(GLOB EXEFILES_DEBUG ${CURRENT_PACKAGES_DIR}/debug/bin/*.exe)
    file(COPY ${EXEFILES_RELEASE} DESTINATION ${CURRENT_PACKAGES_DIR}/tools/pcl)
    file(REMOVE ${EXEFILES_RELEASE} ${EXEFILES_DEBUG})
    vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/pcl)
endif()

file(COPY ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/pcl)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/pcl/LICENSE.txt ${CURRENT_PACKAGES_DIR}/share/pcl/copyright)
