#!/usr/bin/env bash

set -e
set -o pipefail

RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m"

### ====== ###
echo -e "${BLUE}  > Cleaning old builds...${NC}"

pod cache clean --all
pod deintegrate MapwizeUI.xcodeproj
rm -rf build ui Pods
mkdir -p build ui/simulator ui/device
### ====== ###

### ====== ###
echo -e "${BLUE}  > Installing pods...${NC}"

BUILD_RELEASE="true" pod update
BUILD_RELEASE="true" pod install
### ====== ###

### ====== ###
echo -e "${BLUE}  > Building the UI for Cocoapods...${NC}"

# Build UI for simulator
xcodebuild -workspace MapwizeUIApp.xcworkspace -scheme MapwizeUI -configuration Release -sdk iphonesimulator CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY= ONLY_ACTIVE_ARCH=NO ARCHS="i386 x86_64" BITCODE_GENERATION_MODE="bitcode" DSTROOT="$(pwd)/build/dst" OBJROOT="$(pwd)/build/obj" OTHER_CFLAGS="-fembed-bitcode" SHARED_PRECOMPS_DIR="$(pwd)/build/shared" SYMROOT="$(pwd)/build/sym" build | xcpretty -s
if [ ! -d ./build/sym/Release-iphonesimulator/MapwizeUI.framework ]; then
  echo -e "${RED}  > The MapwizeUI framework for simulator does not exist${NC}"
  exit 1
fi
cp -R build/sym/Release-iphonesimulator/MapwizeUI.framework ui/simulator

# Clean
rm -rf build
mkdir build

# Build UI for device
xcodebuild -workspace MapwizeUIApp.xcworkspace -scheme MapwizeUI -configuration Release -sdk iphoneos CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY= ONLY_ACTIVE_ARCH=NO ARCHS="arm64 armv7" BITCODE_GENERATION_MODE="bitcode" DSTROOT="$(pwd)/build/dst" OBJROOT="$(pwd)/build/obj" OTHER_CFLAGS="-fembed-bitcode" SHARED_PRECOMPS_DIR="$(pwd)/build/shared" SYMROOT="$(pwd)/build/sym" build | xcpretty -s
if [ ! -d ./build/sym/Release-iphoneos/MapwizeUI.framework ]; then
  echo -e "${RED}  > The MapwizeUI framework for device does not exist${NC}"
  exit 1
fi
cp -R build/sym/Release-iphoneos/MapwizeUI.framework ui/device
cp -R build/sym/Release-iphoneos/MapwizeUI.framework ui

# Merge both UIs
lipo -create "ui/simulator/MapwizeUI.framework/MapwizeUI" "ui/device/MapwizeUI.framework/MapwizeUI" -output "ui/MapwizeUI.framework/MapwizeUI"
### ====== ###

### ====== ###
echo -e "${BLUE}  > Shipping the UI...${NC}"

(cd "ui"; zip -qr "MapwizeUI.framework.zip" "MapwizeUI.framework")
if [ ! -f ./ui/MapwizeUI.framework.zip ]; then
  echo -e "${RED}  > The MapwizeUI.framework.zip does not exist${NC}"
  exit 1
fi
### ====== ###

exit 0
