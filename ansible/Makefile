.PHONY: all \
    accounts-role common  nfs lvm docker install-k8s master-init worker-join cni \
     firewall

# 전체 실행 (순차적으로 실행)
all:  common nfs lvm docker install-k8s master-init worker-join

# 사용자 계정 권한 설정
accounts-role:
	ansible-playbook playbooks/accounts-role.yaml -i inventory/hosts.ini

# 공통 시스템 설정 (패키지 설치, swap 비활성화 등)
common:
	ansible-playbook playbooks/common.yaml -i inventory/hosts.ini

# nfs 설치 및 마운트
nfs:
	ansible-playbook playbooks/setup-nfs.yaml -i inventory/hosts.ini

# lvm 추가
lvm:
	ansible-playbook playbooks/extend_lvm_6gb.yaml -i inventory/hosts.ini

# Docker 설치
docker:
	ansible-playbook playbooks/docker.yaml -i inventory/hosts.ini

# Kubernetes 설치
install-k8s:
	ansible-playbook playbooks/k8s/install-k8s.yaml -i inventory/hosts.ini

# 마스터 노드 초기화
master-init:
	ansible-playbook playbooks/k8s/master-init.yaml -i inventory/hosts.ini

# 워커 노드 조인
worker-join:
	ansible-playbook playbooks/k8s/worker-join.yaml -i inventory/hosts.ini

# CNI 설치 (예: Calico)
cni:
	ansible-playbook playbooks/k8s/cni.yaml -i inventory/hosts.ini




# 방화벽 설정
firewall:
	ansible-playbook playbooks/firewall.yaml -i inventory/hosts.ini

