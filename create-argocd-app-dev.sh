#!/bin/bash
set -ex

argocd app create hello-tanzu-dev \
  --repo https://github.com/making/hello-tanzu-deployment.git \
  --path dev \
  --config-management-plugin ytt \
  --dest-server https://192.168.11.114:6443 \
  --dest-namespace demo-dev \
  --sync-policy automated \
  --auto-prune