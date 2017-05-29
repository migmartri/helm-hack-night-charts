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

# USAGE: repo-sync.sh <commit-changes?>

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
    echo "  REPO_URL: $REPO_URL"
    echo "  BUILD_DIR: $BUILD_DIR"
    echo "  REPO_DIR: $REPO_DIR"
    echo "  TRAVIS: $TRAVIS"
    echo "  COMMIT_CHANGES: $COMMIT_CHANGES"
}

COMMIT_CHANGES="${1}"
: ${COMMIT_CHANGES:=false}
: ${TRAVIS:=false}
REPO_URL=https://migmartri.github.io/helm-hack-night-charts
BUILD_DIR=$(mktemp -d)
# Current directory
REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
COMMIT_MSG="Updating chart repository"

show_important_vars

if [ $TRAVIS != "false" ]; then
  log "Configuring git for Travis-ci"
  travis_setup_git
else
  git remote add upstream git@github.com:migmartri/helm-hack-night-charts.git || true
fi

git fetch upstream
git checkout gh-pages

log "Initializing build directory with existing charts index"
if [ -f index.yaml ]; then
  cp index.yaml $BUILD_DIR
fi

git checkout master

# Package all charts and update index in temporary buildDir
log "Packaging charts from source code"
pushd $BUILD_DIR
  for dir in `ls $REPO_DIR/charts`;do
    log "Packaging $dir"
    helm dep update $REPO_DIR/charts/$dir
    helm package $REPO_DIR/charts/$dir
  done

  log "Indexing repository"
  if [ -f index.yaml ]; then
    helm repo index --url ${REPO_URL} --merge index.yaml .
  else
    helm repo index --url ${REPO_URL} .
  fi
popd

git reset upstream/gh-pages
cp $BUILD_DIR/* $REPO_DIR

# Commit changes are not enabled during PR
if [ $COMMIT_CHANGES != "false" ]; then
  log "Commiting changes to gh-pages branch"
  git add *.tgz index.yaml
  git commit --message "$COMMIT_MSG"
  git push -q upstream HEAD:gh-pages
fi

log "Repository cleanup and reset"
git reset --hard upstream/master
git clean -df .
