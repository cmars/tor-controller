
all: build

.PHONY: build
build: tor-controller-manager tor-local-manager

tor-controller-manager:
	go build -o tor-controller-manager cmd/controller-manager/main.go

tor-local-manager:
	go build -o tor-local-manager cmd/tor-local-manager/main.go

.PHONY: tor-daemon-manager_docker
tor-daemon-manager_docker:
	docker build . -f Dockerfile.tor-daemon-manager -t ghcr.io/cmars/tor-controller/tor-daemon-manager:master

.PHONY: tor-controller_docker
tor-controller_docker:
	docker build . -f Dockerfile.controller -t ghcr.io/cmars/tor-controller/tor-controller-manager:master

.PHONY: images
images: tor-daemon-manager_docker tor-controller_docker

install.yaml:
	kubebuilder create config --name=tor --controller-image=ghcr.io/cmars/tor-controller/tor-controller-manager:master --output=hack/install.yaml
