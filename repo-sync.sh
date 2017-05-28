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

REPO_URL=https://migmartri.github.io/helm-hack-night-charts
BUILD_DIR=`mktemp -d`
# Current directory
REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Package all charts and update index
pushd $BUILD_DIR
  for dir in `ls $REPO_DIR/charts`;do
    helm dep update $REPO_DIR/charts/$dir
    helm package $REPO_DIR/charts/$dir
  done
  helm repo index --url ${REPO_URL} .
popd
