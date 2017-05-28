#!/bin/bash -e
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
#

log () {
  echo -e "\033[0;33m$(date "+%H:%M:%S")\033[0;37m ==> $1."
}

travis_setup_git() {
  git config user.email "travis@travis-ci.org"
  git config user.name "Travis CI"
  COMMIT_MSG="Updating chart repository, travis build #$TRAVIS_BUILD_NUMBER"
  git remote add upstream "https://$GH_TOKEN@github.com/migmartri/helm-hack-night-charts.git"
}

show_important_vars() {
    echo "  REPO_URL: $REPO_UR"
    echo "  BUILD_DIR: $BUILD_DIR"
    echo "  REPO_DIR: $REPO_DIR"
    echo "  TRAVIS: $TRAVIS"
}

REPO_URL=https://migmartri.github.io/helm-hack-night-charts
BUILD_DIR=$(mktemp -d)
# Current directory
REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
COMMIT_MSG="Updating chart repository"

show_important_vars

if [ ! -z $TRAVIS ]; then
  log "Configuring git for Travis-ci"
  travis_setup_git
else
  git remote add upstream git@github.com:migmartri/helm-hack-night-charts.git || true
fi

git fetch upstream

log "Initialize build directory with existing charts"
git checkout gh-pages
cp * $BUILD_DIR
git checkout master

# Package all charts and update index in temporary buildDir
pushd $BUILD_DIR
  for dir in `ls $REPO_DIR/charts`;do
    log "Packaging $dir"
    helm dep update $REPO_DIR/charts/$dir
    helm package $REPO_DIR/charts/$dir
  done

  log "Indexing repository"
  helm repo index --url ${REPO_URL} --merge index.yaml .
popd

git checkout gh-pages
cp $BUILD_DIR/* $REPO_DIR

log "Commiting changes to gh-pages branch"
git add *.tgz index.yaml
git commit --message "$COMMIT_MSG"
git push upstream HEAD:gh-pages

log "Reset state"
git checkout master
