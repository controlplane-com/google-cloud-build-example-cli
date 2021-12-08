#!/bin/bash

# exit when any command fails
set -e

apt-get -y update && apt-get -y install npm
npm install -g @controlplane/cli
cpln --version
cpln profile update default --token ${CPLN_TOKEN}
cpln image docker-login
cpln image build --name ${IMAGE} --dockerfile ./Dockerfile --push
cd cpln
sed -i "s/ORG_NAME/${CPLN_ORG}/" cpln-gvc.yaml
sed -i "s/GVC_NAME/${CPLN_GVC_NAME}/" cpln-gvc.yaml
sed -i "s/WORKLOAD_NAME/${CPLN_WORKLOAD_NAME}/" cpln-workload.yaml
sed -i "s/IMAGE_NAME_TAG/${IMAGE}/" cpln-workload.yaml
cpln apply -f cpln-gvc.yaml
cpln apply -f cpln-workload.yaml --gvc ${CPLN_GVC_NAME}
