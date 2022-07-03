#!/bin/bash

PACKAGE_NAME=$1
PACKAGE_VERSION=$2
PACKAGE_REVISION=$3
PACKAGE_ARCHITECTURE=$4
IPFS_EXECUTABLE=ipfs

START_DIR=$PWD
FILES_DIR=$PWD/files
OUTPUT_DIR=$PWD/output
TEMP_DIR=$PWD/temp
INPUT_DIR=$PWD/input

echo "[Packager] Starting in directory: $START_DIR"

echo "[Packager] Preparing temp and output directories"
rm -rf $TEMP_DIR
rm -rf $OUTPUT_DIR
mkdir -p $TEMP_DIR
mkdir -p $OUTPUT_DIR

echo "[Packager] Switching to temp directory"
cd $TEMP_DIR

echo "[Packager] Current directory"
pwd

FULL_NAME="${PACKAGE_NAME}_${PACKAGE_VERSION}-${PACKAGE_REVISION}_${PACKAGE_ARCHITECTURE}"
echo "[Packager] Full Name = ${FULL_NAME}"

echo "[Packager] Copying files"
mkdir ${FULL_NAME}
cp -r $FILES_DIR/* ${FULL_NAME}/
mkdir -p ${FULL_NAME}/usr/local/bin
chmod u+x $INPUT_DIR/$IPFS_EXECUTABLE
cp $INPUT_DIR/$IPFS_EXECUTABLE ${FULL_NAME}/usr/local/bin/$IPFS_EXECUTABLE

echo "[Packager] Updating control file version"
sed -i "s/{{package}}/${PACKAGE_NAME}/g" ${FULL_NAME}/DEBIAN/control
sed -i "s/{{version}}/${PACKAGE_VERSION}/g" ${FULL_NAME}/DEBIAN/control
sed -i "s/{{architecture}}/${PACKAGE_ARCHITECTURE}/g" ${FULL_NAME}/DEBIAN/control

echo "[Packager] Final packaging file structure"
tree ${FULL_NAME}

echo "[Packager] Building deb"
dpkg-deb -Z gzip --build --root-owner-group ${FULL_NAME}

echo "[Packager] Creating control_version file"
echo ${PACKAGE_VERSION}-${PACKAGE_REVISION} > $OUTPUT_DIR/control_version

echo "[Packager] Copying output DEB"
mkdir -p $OUTPUT_DIR/build
cp ${FULL_NAME}.deb $OUTPUT_DIR/build/

echo "[Packager] Preparing checksum"
cd $OUTPUT_DIR/build/
sha256sum ${FULL_NAME}.deb > SHA256SUM

echo "[Packager] Cleaning up temp folder"
cd $START_DIR
rm -rf $TEMP_DIR
