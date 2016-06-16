#!/bin/bash
set -o errexit

rm -rf public
mkdir public

# config
git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"

# build (CHANGE THIS)
make

# deploy
cd build
git init
git add .
git commit -m "Deploy to Github Pages"
git push --force --quiet "https://${GITHUB_TOKEN}@$github.com/${GITHUB_REPO}.git" master:gh-pages > /dev/null 2>&1
