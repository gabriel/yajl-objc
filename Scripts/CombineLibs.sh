#!/bin/sh

OUTPUT_DIR=${BUILD_DIR}/Combined${BUILD_STYLE}
OUTPUT_FILE=libYAJLIPhone.a
ZIP_DIR=${BUILD_DIR}/Zip

if [ ! -d ${OUTPUT_DIR} ]; then
	mkdir ${OUTPUT_DIR}
fi

# Combine lib files
lipo -create "${BUILD_DIR}/${BUILD_STYLE}-iphoneos/libYAJLIPhoneDevice${FLAVOR}.a" "${BUILD_DIR}/${BUILD_STYLE}-iphonesimulator/libYAJLIPhoneSimulator${FLAVOR}.a" -output ${OUTPUT_DIR}/${OUTPUT_FILE}

# Copy to direcory for zipping 
mkdir ${ZIP_DIR}
cp ${OUTPUT_DIR}/${OUTPUT_FILE} ${ZIP_DIR}
cp ${BUILD_DIR}/${BUILD_STYLE}-iphonesimulator/*.h ${ZIP_DIR}

cd ${ZIP_DIR}
zip -m libYAJLIPhone-${YAJL_VERSION}.zip *
mv libYAJLIPhone-${YAJL_VERSION}.zip ..
rm -rf ${ZIP_DIR}
