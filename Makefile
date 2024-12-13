CHART_NAME = "charts/nginx-sandbox"
RELEASE_NAME = "nginx-sandbox-0"

.PHONY: check
check:
	helm install --dry-run --debug $(RELEASE_NAME) $(CHART_NAME)

.PHONY: apply
apply:
	helm install $(RELEASE_NAME) $(CHART_NAME)

.PHONY: delete
delete:
	helm delete $(RELEASE_NAME)

.PHONY: reload
reload: delete apply

.PHONY: test
test: lint reload
	helm test $(RELEASE_NAME) --logs

.PHONY: lint
lint:
	helm lint --strict $(CHART_NAME)
