# 경로 정의
TERRAFORM_DIR = terraform/aws
ANSIBLE_DIR = ansible
HELM_DIR = helm
MANIFEST_DIR = manifest
.PHONY: all terraform ansible helm clean

# 전체 실행: terraform → ansible → helm
all: terraform ansible helm
	@echo "🎉 하이브리드 클라우드 전체 구성 완료!"

# Terraform 실행 (init → apply)
terraform:
	@echo "🔧 [Terraform] 인프라 구성 중..."
	cd $(TERRAFORM_DIR) && make all && make output-json

# Ansible 실행 (서버 초기화 + VPN + Kubernetes)
ansible:
	@echo "🛠️ [Ansible] 온프레미스 구성 중..."
	cd $(ANSIBLE_DIR) && make all

# Helm 배포 (앱 설치용 — 선택)
helm:
	@echo "🚀 [Helm] Kubernetes 앱 배포 중..."
	cd $(HELM_DIR) && make deploy || echo "ℹ️ helm/Makefile 없거나 배포 대상 없음"

# 정리 (Terraform destroy)
clean:
	@echo "🔥 전체 리소스 정리 중..."
	cd $(TERRAFORM_DIR) && make destroy