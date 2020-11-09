#!/usr/bin/env bash

set -e
set -o pipefail

RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m"

function usage {
  echo -e "${RED}Usage: ./publish-ui-cocoapods.sh --tag=\$TAG"
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
echo -e "${BLUE}  > Publishing the podspec \"MapwizeUI.podspec\"...${NC}"
sed -i -E 's#(s\.version.*= ).*#\1"'${TAG}'"#i' ./MapwizeUI.podspec
pod trunk push MapwizeUI.podspec --allow-warnings
### ====== ###

exit 0
