#!/bin/bash -ex
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

travis_setup_git() {
  git config user.email "travis@travis-ci.org"
  git config user.name "Travis CI"
  COMMIT_MSG="Updating chart repository, travis build #$TRAVIS_BUILD_NUMBER"
  git remote add upstream "https://$GH_TOKEN@github.com/migmartri/helm-hack-night-charts.git"
}

REPO_URL=https://migmartri.github.io/helm-hack-night-charts
BUILD_DIR=$(mktemp -d)
# Current directory
REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
COMMIT_MSG="Updating chart repository"

# Package all charts and update index in temporary buildDir
pushd $BUILD_DIR
  for dir in `ls $REPO_DIR/charts`;do
    helm dep update $REPO_DIR/charts/$dir
    helm package $REPO_DIR/charts/$dir
  done
  helm repo index --url ${REPO_URL} .
popd

if [! -z $TRAVIS ]; then
  travis_setup_git
else
  git remote add upstream git@github.com:migmartri/helm-hack-night-charts.git || true
fi

git fetch upstream
git reset upstream/gh-pages
cp $BUILD_DIR/* $REPO_DIR

git add -A $REPO_DIR
git commit --message "$COMMIT_MSG"
git push upstream HEAD:gh-pages
