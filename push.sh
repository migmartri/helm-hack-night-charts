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

setup_git() {
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis CI"

  git remote add upstream "https://$GH_TOKEN@github.com/migmartri/helm-hack-night-charts.git"
  git fetch upstream
}

commit_files() {
  git add docs/*
  git commit --message "Travis build: $TRAVIS_BUILD_NUMBER"
  git push upstream HEAD:master
}


if [ "$TRAVIS_BRANCH" != "master" ]
then
  echo "\$TRAVIS_BRANCH" needs to be master to continue.
  exit 0
fi

setup_git
commit_files
