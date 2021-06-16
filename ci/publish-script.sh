#!/usr/bin/env bash

RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m"

./ci/publish-ui-cocoapods.sh --tag="$CI_COMMIT_REF_NAME"
./ci/build-jazzy-doc.sh --tag="$CI_COMMIT_REF_NAME"
zip -r iosdoc.zip docs > /dev/null

git diff --exit-code HEAD MapwizeUI.podspec > /dev/null
if [ $? -ne 0 ]; then
    echo -e "${BLUE}  > Synchronizing the new Podspec version into the master branch...${NC}"
    git checkout master
    git add MapwizeUI.podspec
    git commit -m ":robot: chore: updating the Podspec version to $CI_COMMIT_REF_NAME :robot:"
    git push origin HEAD:master > /dev/null
fi

release_notes=$(sed -n "/^## ${CI_COMMIT_REF_NAME}$/,/^## /p" changelog.md | grep -E "^(\*|-|\s+)" | sed ':a;N;$!ba;s/\n/\\n/g')

echo -e "${BLUE}  > Creating or retrieving the release linked to \"$CI_COMMIT_REF_NAME\"...${NC}"
response=$(http \
    --ignore-stdin \
    --check-status \
    GET \
    https://api.github.com/repos/Mapwize/mapwize-ui-ios/releases/tags/$CI_COMMIT_REF_NAME \
    "Accept:application/vnd.github.v3+json" \
    "Authorization: token $GITHUB_TOKEN")
if [ $? -ne 0 ]; then
    response=$(http \
        --ignore-stdin \
        --check-status \
        POST \
        https://api.github.com/repos/Mapwize/mapwize-ui-ios/releases \
        "Accept:application/vnd.github.v3+json" \
        "Authorization: token $GITHUB_TOKEN" \
        tag_name="$CI_COMMIT_REF_NAME" \
        body="$release_notes")
fi

# We need to delete the iosdoc.zip asset first if it exists, otherwise the upload will fail
upload_url=$(echo $response | jq -re '.upload_url')
upload_url=${upload_url%{?*}
asset_id=$(echo $response | jq -re '.assets | .[] | select(.name == "iosdoc.zip") | .id')
if [ $? -eq 0 ]; then
    http \
        --ignore-stdin \
        --check-status \
        DELETE \
        https://api.github.com/repos/Mapwize/mapwize-ui-ios/releases/assets/$asset_id \
        "Accept:application/vnd.github.v3+json" \
        "Authorization: token $GITHUB_TOKEN" &>/dev/null
fi

echo -e "${BLUE}  > Uploading the release asset \"iosdoc.zip\" for \"$CI_COMMIT_REF_NAME\"...${NC}"
http \
    --ignore-stdin \
    --check-status \
    POST \
    "$upload_url?name=iosdoc.zip" \
    "Content-Type:application/zip" \
    "Authorization: token $GITHUB_TOKEN" \
    @iosdoc.zip &>/dev/null

exit $?
