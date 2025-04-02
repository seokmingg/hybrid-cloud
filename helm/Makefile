### ArgoCD Install Target ###
ARGOCD_NAMESPACE=argocd
ARGOCD_HELM_NAME=argocd
ARGOCD_HELM_REPO=https://argoproj.github.io/argo-helm
ARGOCD_HELM_CHART=argo-cd
ARGOCD_HELM_VERSION=5.51.6
ARGOCD_VALUES=argocd/values.onprem.yaml


.PHONY: install-nfs-provisioner install-istio-onprem install-istio-aws install-cert-manager apply-cert\
 install-harbor-onprem upgrade-harbor-onprem uninstall-harbor-onprem argocd-install argocd-uninstall argocd-status




install-nfs-provisioner:
	helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
	helm repo update
	kubectl create namespace nfs-provisioner || true
	helm upgrade --install nfs-subdir-external-provisioner \
	  nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
	  -n nfs-provisioner \
	  --set nfs.server=192.168.0.100 \
	  --set nfs.path=/mnt/nfs-storage \
	  --set storageClass.name=nfs-storage \
	  --set storageClass.defaultClass=true \
	  --set storageClass.reclaimPolicy=Retain

install-istio-onprem:
	helm repo add istio https://istio-release.storage.googleapis.com/charts
	helm repo update
	kubectl create namespace istio-system || true

	helm upgrade --install istio-base \
	  --repo https://istio-release.storage.googleapis.com/charts \
	  base \
	  -n istio-system \
	  -f istio/base/values.onprem.yaml

	helm upgrade --install istiod \
	  --repo https://istio-release.storage.googleapis.com/charts \
	  istiod \
	  -n istio-system \
	  -f istio/control-plane/values.onprem.yaml

	helm upgrade --install istio-ingressgateway \
	  --repo https://istio-release.storage.googleapis.com/charts \
	  gateway \
	  -n istio-system \
	  -f istio/gateway/values.onprem.yaml

install-istio-aws:
	helm repo add istio https://istio-release.storage.googleapis.com/charts
	helm repo update
	kubectl create namespace istio-system || true
	helm install istio-base istio/base \
	  -n istio-system \
	  -f istio/base/values.aws.yaml
	helm install istiod istio/istiod \
	  -n istio-system \
	  -f istio/control-plane/values.aws.yaml
	helm install istio-ingressgateway istio/gateway \
	  -n istio-system \
	  -f istio/gateway/values.aws.yaml


install-cert-manager:
	helm repo add jetstack https://charts.jetstack.io
	helm repo update
	kubectl create namespace cert-manager || true
	helm upgrade --install cert-manager jetstack/cert-manager \
	  --namespace cert-manager \
	  --set installCRDs=true

apply-cert:
	kubectl apply -f cert-manager/cluster-issuer-dns.yaml
	kubectl apply -f cert-manager/wildcard-certificate.yaml

install-harbor-onprem:
	helm repo add harbor https://helm.goharbor.io
	helm repo update
	kubectl create namespace harbor || true
	helm install harbor harbor/harbor \
	  -n harbor \
	  -f harbor/values.onprem.yaml

upgrade-harbor-onprem:
	helm upgrade harbor harbor/harbor \
	  -n harbor \
	  -f harbor/values.onprem.yaml

uninstall-harbor-onprem:
	helm uninstall harbor -n harbor

argocd-install:
	@echo "🔧 Create namespace if not exists..."
	kubectl get ns $(ARGOCD_NAMESPACE) || kubectl create ns $(ARGOCD_NAMESPACE)
	@echo "📦 Add ArgoCD Helm repo..."
	helm repo add argo $(ARGOCD_HELM_REPO) || true
	helm repo update
	@echo "🚀 Installing ArgoCD via Helm..."
	helm upgrade --install $(ARGOCD_HELM_NAME) argo/$(ARGOCD_HELM_CHART) \
		--version $(ARGOCD_HELM_VERSION) \
		--namespace $(ARGOCD_NAMESPACE) \
		-f $(ARGOCD_VALUES)

argocd-uninstall:
	@echo "🧹 Uninstalling ArgoCD..."
	helm uninstall $(ARGOCD_HELM_NAME) -n $(ARGOCD_NAMESPACE)
	kubectl delete ns $(ARGOCD_NAMESPACE) --ignore-not-found

argocd-status:
	kubectl get all -n $(ARGOCD_NAMESPACE)