GCP_PROJECT=vimeo-infra
PROJECT=vimeo-flume
VERSION=$$(mvn org.apache.maven.plugins:maven-help-plugin:3.1.0:evaluate -Dexpression=project.version -q -DforceStdout)
build-image: ## Build a container image locally. You will need Docker installed for this.
	mvn clean install -DskipTests -Drat.skip=true -Dspotbugs.skip=true -Dcheckstyle.skip=true -Dpmd.skip=true -U;\
 	docker build -t $(PROJECT):$(VERSION) --build-arg VERSION=$(VERSION) .

push-image: ## Push the current version (if built. Run build-image first) to Vimeo's GCP registry.
	@[ -z "${VERSION}" ] && echo "Need VERSION defined" && exit 1 ;\
	docker tag $(PROJECT):${VERSION} gcr.io/$(GCP_PROJECT)/$(PROJECT):$(VERSION) ;\
	docker push gcr.io/$(GCP_PROJECT)/$(PROJECT):$(VERSION)

list-built-versions: ## List versions available in Vimeo's container registry.
	echo $$(docker images | grep $(PROJECT))

list-pushed-versions: ## List versions available in Vimeo's container registry.
	gcloud --project=$(GCP_PROJECT) container images list-tags gcr.io/$(GCP_PROJECT)/$(PROJECT)

help: ## Prints this help
	@grep -E '^([a-zA-Z_-]|\%|\/)+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {sub(/\%/, "<blah>", $$1)}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
