#!/bin/bash
set -ex

argocd app create hello-tanzu-prod \
  --repo https://github.com/making/hello-tanzu-deployment.git \
  --path prod \
  --config-management-plugin ytt \
  --dest-server https://192.168.11.114:6443 \
  --dest-namespace demo \
  --sync-policy automated \
  --auto-prune