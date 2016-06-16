#!/bin/bash
set -o errexit

git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"

cd build/web
git init
git add --a
git commit -m "Deploy to Github Pages"
git push --force --quiet "https://${GITHUB_TOKEN}@github.com/${GITHUB_REPO}.git" master:gh-pages
