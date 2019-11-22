include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO lighttransport/nanort
    REF c85fe7a10be5baf8242c81288718c244f25d0183
    SHA512 0917ffdc51db9d5f936fc79d5b3d1886c5163470e650a2613200417a9e7a344b75c76c115f64160877d6a3480f7eda7884f3097927eb371267cc6d3c30afed37
    HEAD_REF master
)

file(COPY ${SOURCE_PATH}/nanort.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)

configure_file(${SOURCE_PATH}/LICENSE ${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright COPYONLY)
