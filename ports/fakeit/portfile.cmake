vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO eranpeer/FakeIt
    REF 38c118c2be2fe33148545b1c32dc568eeabe1f23 #v2.1.1
    SHA512 32b91a1d2fc156cd2293774fea0196492356411ad2437acde1488e087a62f921e13dd75d850be3d50c380e3d525759273eba5b40771fe140581d5ffaefe16842
    HEAD_REF master
)

file(COPY "${SOURCE_PATH}/single_header/" DESTINATION "${CURRENT_PACKAGES_DIR}/include")

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
