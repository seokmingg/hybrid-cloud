.PHONY: all \
    accounts-role common docker install-k8s master-init worker-join cni\
    vpn firewall

# 전체 실행 (순차적으로 실행)
all: accounts-role common docker install-k8s master-init worker-join cni vpn firewall

# 사용자 계정 권한 설정
accounts-role:
	ansible-playbook playbooks/accounts-role.yaml -i inventory/hosts.ini

# 공통 시스템 설정 (패키지 설치, swap 비활성화 등)
common:
	ansible-playbook playbooks/common.yaml -i inventory/hosts.ini

# Docker 설치
docker:
	ansible-playbook playbooks/docker.yaml -i inventory/hosts.ini


# Kubernetes 설치 (kubeadm, kubelet, kubectl 설치)
install-k8s:
	ansible-playbook playbooks/install-k8s.yaml -i inventory/hosts.ini

# 마스터 노드 초기화 (kubeadm init)
master-init:
	ansible-playbook playbooks/master-init.yaml -i inventory/hosts.ini

# 워커 노드 조인 (kubeadm join)
worker-join:
	ansible-playbook playbooks/worker-join.yaml -i inventory/hosts.ini
# cni 설치
cni:
	ansible-playbook playbooks/cni.yaml -i inventory/hosts.ini

# VPN 설정
vpn:
	ansible-playbook playbooks/configure-vpn.yaml -i inventory/hosts.ini

# 방화벽 설정
firewall:
	ansible-playbook playbooks/firewall.yaml -i inventory/hosts.ini
