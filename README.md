## Example using ytt + kbld with ArgoCD


In order to use ytt with ArgoCD, you need to install ytt on repo-server and set configManagementPlugins on argocd-cm. [Here](https://gist.github.com/making/6f0852541959d39c27bd238e9deb6d54) is a set of sample overlay files to achieve these.
For example, when installing the Argo CD, customize it as follows.

```
ytt --ignore-unknown-comments=true \
    -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml \
    -f https://gist.github.com/making/6f0852541959d39c27bd238e9deb6d54/raw/b37698c8090ad4304e15bdefe522da76d16c86da/argocd-repo-server.yml \
    -f https://gist.github.com/making/6f0852541959d39c27bd238e9deb6d54/raw/b37698c8090ad4304e15bdefe522da76d16c86da/argocd-cm.yml \
    | kubectl apply -f-
```

Verify manifest to be installed on dev and prod enviroments

```
# Dev
ytt -f base -f dev

# Prod
ytt -f base -f prod
```

Given the ArgoCD server configured below

```
argocd login argo.orange.maki.lol --grpc-web --username admin --password $(kubectl get pod -n argocd -l app.kubernetes.io/component=server -o jsonpath='{.items[0].metadata.name}')
argocd account update-password --new-password admin --current-password $(kubectl get pod -n argocd -l app.kubernetes.io/component=server -o jsonpath='{.items[0].metadata.name}')
argocd login argo.orange.maki.lol --grpc-web --username admin --password admin 
argocd cluster add $(kubectl config current-context)
```

Create apps for dev and prod environment as follows

```
# Dev
argocd app create hello-tanzu-dev \
  --repo https://github.com/making/hello-tanzu-deployment.git \
  --path dev \
  --config-management-plugin ytt \
  --dest-server https://192.168.11.114:6443 \
  --dest-namespace demo-dev \
  --sync-policy automated \
  --auto-prune

# Prod
argocd app create hello-tanzu-prod \
  --repo https://github.com/making/hello-tanzu-deployment.git \
  --path prod \
  --config-management-plugin ytt \
  --dest-server https://192.168.11.114:6443 \
  --dest-namespace demo \
  --sync-policy automated \
  --auto-prune
```

You will see 2 apps in ArgoCD UI as follows

![image](https://user-images.githubusercontent.com/106908/107842131-7d893280-6e04-11eb-99c5-113e5def04ea.png)

![image](https://user-images.githubusercontent.com/106908/107842149-8843c780-6e04-11eb-84cc-9db8cf2c99c7.png)