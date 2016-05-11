GIT_SHA := $(shell git log -1 --pretty=format:"%h")

build-install:
	go get github.com/mitchellh/gox

build:
	go build \
		-ldflags "-X validator.progBuild='$(GIT_SHA)'" \
		-o $(GOPATH)/bin/data-models-validator ./cmd/validator

# Build and tag binaries for each OS and architecture.
dist-build:
	mkdir -p dist

	gox -output="dist/{{.OS}}-{{.Arch}}/data-models-validator" \
		-ldflags "-X validator.progBuild='$(GIT_SHA)'" \
		-os="linux windows darwin" \
		-arch="amd64" \
		./cmd/validator > /dev/null

dist-zip:
	cd dist && zip data-models-validator-linux-amd64.zip linux-amd64/*
	cd dist && zip data-models-validator-windows-amd64.zip windows-amd64/*
	cd dist && zip data-models-validator-darwin-amd64.zip darwin-amd64/*

dist: dist-build dist-zip


.PHONY: build dist-build dist
