# 📦 helm/grafana/Makefile

NAME := grafana
NAMESPACE := monitoring
VALUES := values.onprem.yaml

install:
	helm upgrade --install $(NAME) grafana \
		-n $(NAMESPACE) --create-namespace \
		-f $(VALUES) --repo https://grafana.github.io/helm-charts

uninstall:
	helm uninstall $(NAME) -n $(NAMESPACE)

status:
	kubectl get all -n $(NAMESPACE) -l app.kubernetes.io/name=grafana