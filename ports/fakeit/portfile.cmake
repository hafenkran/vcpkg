vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO eranpeer/FakeIt
    REF 78ca536e6b32f11e2883d474719a447915e40005 #v2.3.0
    SHA512 b3a76d278217d177e2222d6e4c782c8ee08a7b6244e5f89fd25b22faffc8f0cf402c1d04763fb6f6ef37272738adf5dd7ff7a0437c1bc9a5043765058fa2a648
    HEAD_REF master
)

file(COPY "${SOURCE_PATH}/single_header/" DESTINATION "${CURRENT_PACKAGES_DIR}/include")

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
