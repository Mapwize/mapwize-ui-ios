#!/usr/bin/env bash

set -e
set -o pipefail

RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m"

function usage {
  echo -e "${RED}Usage: ./build-jazzy-doc.sh --tag=\$TAG"
}

for i in "$@"; do
  case $i in
    --tag=*)
      TAG="${i#*=}"
      shift # past argument=value
      ;;
    *)
      usage
      exit 1
  esac
done

if [ -z "$TAG" ]; then
  usage
  exit 1
fi;

### ====== ###
echo -e "${BLUE}  > Cleaning old docs...${NC}"

rm -rf docs
mkdir -p docs
### ====== ###

### ====== ###
echo -e "${BLUE}  > Generating the documentation with jazzy...${NC}"

jazzy \
    --objc \
    --author Mapwize \
    --author_url https://www.mapwize.io \
    --module-version ${TAG} \
    --umbrella-header MapwizeUI/MapwizeUI.h \
    --framework-root ui/MapwizeUI.framework \
    --module MapwizeUI \
    --readme=docs.md \
    --output docs

rm -rf docs/docsets
### ====== ###

exit 0
