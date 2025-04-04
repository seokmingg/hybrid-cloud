# 📦 helm/prometheus/Makefile

# 사용할 values 파일 경로
VALUES_FILE := values.onprem.yaml
RELEASE_NAME := kube-prometheus
NAMESPACE := monitoring

# Helm repo 설정
.PHONY: init
init:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update

.PHONY: install
install:
	helm upgrade --install $(RELEASE_NAME) prometheus-community/kube-prometheus-stack \
	  -f $(VALUES_FILE) \
	  -n $(NAMESPACE) --create-namespace

.PHONY: uninstall
uninstall:
	helm uninstall $(RELEASE_NAME) -n $(NAMESPACE)

.PHONY: status
status:
	kubectl get all -n $(NAMESPACE)
