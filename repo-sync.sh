#!/bin/bash -xe
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

# Setup Helm
#HELM_URL=https://storage.googleapis.com/kubernetes-helm
#HELM_TARBALL=helm-v2.1.3-linux-amd64.tar.gz
#wget -q ${HELM_URL}/${HELM_TARBALL}
#tar xzfv ${HELM_TARBALL}
#PATH=`pwd`/linux-amd64/:$PATH
#helm init --client-only

REPO_URL=https://migmartri.github.io/helm-hack-night-charts

REPO_DIR=docs

# Package all charts and update index
pushd $REPO_DIR
  for dir in `ls ../charts`;do
    helm dep update ../charts/$dir
    helm package ../charts/$dir
  done
  helm repo index --url ${REPO_URL} --merge ./index.yaml .
popd

