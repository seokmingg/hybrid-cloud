###  프로젝트 개요

이 프로젝트는 **온프레미스 Kubernetes 클러스터에 GitOps 방식을 적용**하여 인프라 및 애플리케이션을 일관되게 운영하고, 향후 AWS EKS 환경에서도 동일한 방식으로 확장 가능하도록 설계된 **하이브리드 클라우드 기반 GitOps 프로젝트**입니다.

현재는 테스트 환경에서 온프레미스 Kubernetes를 중심으로 구축 및 검증을 완료했으며, 향후 이 GitOps 구조를 기반으로 AWS EKS 클러스터도 운영할 예정입니다.

---

###  인프라 구성 및 자동화

- **Ansible을 이용한 온프레미스 Kubernetes 초기 구축**
    - 리눅스 VM에 Docker, cri-dockerd 설치
    - kubeadm으로 init/join 자동화
    - etcd 스냅샷 복구 자동화
    - 쿠버네티스 클러스터 구성에 필요한 기본 설정 자동화

- **GitOps 기반 ArgoCD 운영**
    - ArgoCD 자체를 GitOps로 관리 (App of Apps 방식)
    - cert-manager + Route53 DNS-01 방식으로 와일드카드 인증서 자동 발급
    - Istio Gateway로 서브도메인 통합 관리
    - MetalLB를 통해 온프레미스 환경에서 LoadBalancer 타입 서비스 구현
    - External Secrets Operator(ESO)를 통해 AWS SSM Parameter Store와 연동하여 민감 정보 관리

- **모니터링 및 로깅 시스템 구축**
    - Prometheus, Grafana로 리소스 및 애플리케이션 모니터링
    - Loki + Promtail로 Pod 로그 수집
    - Slack 연동 알림 구성
    - etcd 백업 및 백엔드앱 로그 저장을 **GitOps 기반 Kubernetes CronJob으로 자동화**

- **3티어 애플리케이션 CI/CD**
    - GitHub Actions로 Docker 이미지 빌드 및 Harbor에 자동 푸시
    - 이미지 푸시 후 values.yaml 자동 커밋 → GitOps로 ArgoCD 연동
    - Helm 차트를 통한 ArgoCD 애플리케이션 배포
    - Canary 배포 전략 및 HPA 설정

---

### 🔗 관련 링크

- 자세한 정보는 Notion 문서 참고: [https://www.notion.so/1bcf3c769d45809683f3f79a6207375b?pvs=4](https://www.notion.so/1bcf3c769d45809683f3f79a6207375b?pvs=4)
- GitHub (테스트 앱): [https://github.com/seokmingg/test-hybrid](https://github.com/seokmingg/test-hybrid)

- 호스팅 중인 사이트 (공통 ID/PW: `user` / `A123456z`)
    - ArgoCD: [https://argocdt.seokmin.com](https://argocdt.seokmin.com/)
    - Harbor: [https://harbor.seokmin.com](https://harbor.seokmin.com/)
    - Grafana: [https://grafanat.seokmin.com](https://grafanat.seokmin.com/)
    - Test App: [https://test.seokmin.com](https://test.seokmin.com/)

---

### 📁 디렉토리 구조

```plaintext
hybrid-cloud/
├── ansible/                         # 온프레미스 초기 인프라 설정용 Ansible
│   ├── Makefile                     # ansible 작업 자동화 스크립트
│   ├── ansible.cfg                  # Ansible 설정파일
│   ├── inventory/                   # 호스트 정보 (onprem-master, worker 등)
│   ├── playbooks/                   # install-k8s, restore-etcd 등 주요 작업 정의
│   └── roles/                       # Docker, kubeadm, etcd 관련 역할들
├── helm/                            # Helm 차트 디렉터리 (GitOps 배포 대상)
│   ├── argo-cd/                     # ArgoCD Helm 차트
│   ├── calico/                      # Calico CNI 구성용 Helm 차트
│   ├── grafana/                     # Grafana Helm 차트
│   ├── harbor/                      # Harbor Helm 차트
│   ├── istio/                       # Istio base, gateway 등
│   ├── kube-prometheus-stack/       # Prometheus
│   ├── loki-distributed/            # Loki 
│   └── service/                     # 프론트/백엔드 앱 + PostgreSQL-HA
├── manifests/                       # YAML 리소스 선언 관리 (GitOps로 적용됨)
│   ├── apps/                        # ArgoCD Application 리소스
│   ├── cert-manager/                # ClusterIssuer, Certificate 리소스
│   ├── cronjobs/                    # etcd, 로그 백업용 GitOps CronJob
│   ├── external-secrets/            # ESO 리소스, SecretStore 등
│   ├── infra-project.yaml           # ArgoCD 프로젝트 정의 (infra)
│   ├── istio/                       # Gateway, VirtualService 등 Istio 리소스
│   ├── jobs/                        # one-time 실행 Job
│   ├── monitoring/                  # PrometheusRule
│   ├── root/                        # root-app.yaml 등 App of Apps
│   ├── service-app-project.yaml     # 서비스 앱용 ArgoCD 프로젝트 정의
│   └── service-apps/                # 서비스 앱 Application들