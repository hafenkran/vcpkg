set(PACKAGE_NAME plugin)

ignition_modular_library(
   NAME ${PACKAGE_NAME}
   REF ${PORT}_${VERSION}
   VERSION ${VERSION}
   SHA512 4c497291f8e33aae3a5752607a7fd7b48912e209f0f424ea7b1e6d35f27d1e920d1dd97ee64b7b3846d7d433618742be5d19352cbce8f6f63eccc83a086520ea
   OPTIONS 
   PATCHES
)
