#!/bin/sh -l

set -e

# Default branch is GITHUB_REPOSITORY
if [ -n "${PUBLISH_REPOSITORY}" ]; then
  REPOSITORY=${PUBLISH_REPOSITORY}
else
  REPOSITORY=${GITHUB_REPOSITORY}
fi

# Default branch is gh-pages
if [ -z "${BRANCH}" ]; then
  BRANCH=gh-pages
fi

if [ -z "${PERSONAL_TOKEN}" ]; then
  echo "You must provide the action with either a Personal Access Token or the GitHub Token secret in order to deploy."
  exit 1
fi

# Github workspace.
cd "${GITHUB_WORKSPACE}"

npm install

./node_modules/.bin/hexo generate

cd public

git init

echo Config the safe directory -- workaround
git config --global --add safe.directory $(pwd)
git config --global --list

echo Set user name and user email...
git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"

echo Set remote repository
git remote add origin "https://x-access-token:${PERSONAL_TOKEN}@github.com/${REPOSITORY}.git"

echo Create new branch and add ALL files
git checkout --orphan ${BRANCH}
git add --all

echo Commit and push
git commit --allow-empty -m "Deploying to ${BRANCH}"

git push origin "${BRANCH}" --force

echo "Deploy successfully!"
