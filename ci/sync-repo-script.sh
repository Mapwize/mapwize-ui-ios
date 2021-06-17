#!/usr/bin/env bash

# 1) Updating and commiting the Podfile.lock if modified (on branches only)
# 2) If the Podspec version has been modified, automatically create the tag (on master branch only)
git diff --exit-code HEAD Podfile.lock > /dev/null

if [ $? -ne 0 ]; then
    echo -e "${BLUE}  > Updating the Podfile.lock on the branch \"$CI_COMMIT_BRANCH\"...${NC}"
    git add Podfile.lock
    git commit -m ":robot: chore: updating the Podfile.lock :robot:"
    git push origin HEAD:$CI_COMMIT_BRANCH > /dev/null
elif [ "$CI_COMMIT_BRANCH" == "master" ]; then
    git diff --exit-code -G '^\s+s\.version\s+=.*$' HEAD~1..HEAD > /dev/null

    if [ $? -ne 0 ]; then
        new_tag=$(sed -nE 's#\s+s\.version\s+=\s*"(.+)"#\1#p' MapwizeUI.podspec)
        git rev-list $new_tag.. &> /dev/null
        is_new_tag=$?

        if [ $is_new_tag -ne 0 ]; then
            echo -e "${BLUE}  > Creating the tag \"$new_tag\"...${NC}"
            git tag $new_tag
            git push origin $new_tag > /dev/null
        fi
    fi
fi

exit $?
