# Calico (Tigera Operator) Helm 설치 및 업데이트 (VPN 환경 반영)
# VPN 터널 인터페이스의 영향을 피하기 위해 Calico가 올바른 네트워크 인터페이스(ens33)를 사용하도록 설정합니다.

HELM_REPO_NAME := projectcalico
HELM_REPO_URL  := https://docs.projectcalico.org/charts
NAMESPACE      := kube-system
RELEASE_NAME   := calico
CHART_NAME     := tigera-operator

.PHONY: all add-repo update install

all: add-repo update install

add-repo:
	@echo "Calico Helm repository $(HELM_REPO_URL)를 추가합니다..."
	helm repo add $(HELM_REPO_NAME) $(HELM_REPO_URL) || echo "Repository '$(HELM_REPO_NAME)' already exists, skipping..."

update:
	@echo "Helm repository를 업데이트합니다..."
	helm repo update

install:
	@echo "VPN 문제 해결을 위한 Calico (Tigera Operator) 설치/업데이트를 진행합니다..."
	helm upgrade --install $(RELEASE_NAME) $(HELM_REPO_NAME)/$(CHART_NAME) \
	  --namespace $(NAMESPACE) --create-namespace \
	  --set node.ipAutodetectionMethod="interface=ens33"