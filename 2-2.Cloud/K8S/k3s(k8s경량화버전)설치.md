# K3S 설치 

- 간단한 쿠버네티스 환경 구축 혹은 테스트가 필요한 경우 사용
- 단일 VM에 설치하여 쿠버네티스를 사용가능 
- 경량화 버전이므로 k8s 모든기능은 다 포함되지않음

```
curl -sfL https://get.k3s.io | sh -
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
kubectl get nodes
```

##  k3s 환경에 helm chart 배포
- 쿠버네티스 환경이므로 Helm chart도 배포할수 있음 

### 스크립트를 통해 Helm 설치
```bash
 curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
 chmod 755 get_helm.sh
 ./get_helm.sh
```


### repo 등록 후 차트 배포 

- helm에 argoCD repository 추가
```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
```

- 차트 배포
```bash
$ helm upgrade --install argocd argo/argo-cd 
```