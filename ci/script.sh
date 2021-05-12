#!/usr/bin/env bash

set -e
set -o pipefail

./ci/build-ui-cocoapods.sh

# Updating and commiting the Podfile.lock if modified (on branches only)
if [[ "$TRAVIS_PULL_REQUEST" == "false" ]] && [ -z "$TRAVIS_TAG" ]; then
  git add Podfile.lock
  { git diff-index --quiet HEAD Podfile.lock || git commit -m ":robot: chore: updating the Podfile.lock :robot:"; }
  git push -q https://${GITHUB_TOKEN}@github.com/Mapwize/mapwize-ui-ios.git HEAD:${TRAVIS_BRANCH}
fi;

# If the version has been modified, create the release and tag automatically
if [[ "$TRAVIS_BRANCH" == "master" ]] && [[ "$TRAVIS_PULL_REQUEST" == "false" ]]; then
  git diff --exit-code -G '^\s+s\.version\s+=.*$' HEAD~1..HEAD > /dev/null
  is_modified_version=$?
  if [ $is_modified_version -ne 0 ]; then
    new_tag=$(sed -nE 's#\s+s\.version\s+=\s*"(.+)"#\1#p' MapwizeUI.podspec)
    git rev-list ${new_tag}.. &> /dev/null
    is_new_tag=$?

    if [ $is_new_tag -ne 0 ]; then
      release_notes=$(sed -n "/^## ${new_tag}$/,/^## /p" changelog.md | grep -E "^(\*|-|\s+)" | sed ':a;N;$!ba;s/\n/\\n/g' )
      git tag ${new_tag}
      git push https://${GITHUB_TOKEN}@github.com/Mapwize/mapwize-ui-ios.git ${new_tag}
      res="404" && while [[ "$res" != "200" ]]; do res=$(curl -i -X GET -H "Accept: application/vnd.github.v3+json" -H "Authorization: token ${GITHUB_TOKEN}" https://api.github.com/repos/mapwize/mapwize-ui-ios/releases/tags/${new_tag} | grep Status | sed -nE 's#^Status: ([0-9]{3}) .+$#\1#p'); if [[ "$res" != "200" ]]; then sleep 30; fi; done
      tag_id=$(curl -sS -X GET -H "Accept: application/vnd.github.v3+json" -H "Authorization: token ${GITHUB_TOKEN}" https://api.github.com/repos/mapwize/mapwize-ui-ios/releases/tags/${new_tag} | jq .id)
      curl -sS -X PATCH -H "Accept: application/vnd.github.v3+json" -H "Authorization: token ${GITHUB_TOKEN}" https://api.github.com/repos/mapwize/mapwize-ui-ios/releases/${tag_id} -d "{ \"body\": \"${release_notes}\" }"
    fi;
  fi;
fi;

# Publishing the POD and the doc on a new release
if ! [ -z "$TRAVIS_TAG" ]; then
  ./ci/publish-ui-cocoapods.sh --tag="${TRAVIS_TAG}"
  ./ci/build-jazzy-doc.sh --tag="${TRAVIS_TAG}"
  zip -r iosdoc.zip docs
  ## Commiting the podspec if modified
  git add MapwizeUI.podspec
  { git diff-index --quiet HEAD MapwizeUI.podspec || git commit -m ":robot: chore: updating the Podspec's version to ${TRAVIS_TAG} :robot:"; }
  git switch -c master
  git push -q https://${GITHUB_TOKEN}@github.com/Mapwize/mapwize-ui-ios.git master
fi;
