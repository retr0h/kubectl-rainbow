VENDOR := vendor
PKGS := $(shell go list ./... | /usr/bin/grep -v /$(VENDOR)/)
PKGS_DELIM := $(shell echo $(PKGS) | sed -e 's/ /,/g')
GITCOMMIT ?= $(shell git rev-parse --short HEAD)
GITUNTRACKEDCHANGES := $(shell git status --porcelain --untracked-files=no)
ifneq ($(GITUNTRACKEDCHANGES),)
GITCOMMIT := $(GITCOMMIT)-dirty
endif
VERSION ?= $(shell git describe --tags --always)
BUILDDATE := $(shell date '+%Y/%m/%d %H:%M:%S')
LDFLAGS := -s \
		-w \
		-X 'main.version=$(VERSION)' \
		-X 'main.buildHash=$(GITCOMMIT)' \
		-X 'main.buildDate=$(BUILDDATE)'
BUILDDIR := .build

test: fmt lint vet
	@echo "+ $@"
	go test -parallel 5 -covermode=count ./...

cover:
	@echo "+ $@"
	$(shell [ -e cover.out ] && rm cover.out)
	@go list -f '{{if or (len .TestGoFiles) (len .XTestGoFiles)}}go test -test.v -test.timeout=120s -covermode=count -coverprofile={{.Name}}_{{len .Imports}}_{{len .Deps}}.coverprofile -coverpkg $(PKGS_DELIM) {{.ImportPath}}{{end}}' $(PKGS) | xargs -I {} bash -c {}
	@echo "mode: count" > cover.out
	@grep -h -v "^mode:" *.coverprofile >> "cover.out"
	@rm *.coverprofile
	@go tool cover -html=cover.out -o=cover.html

fmt:
	@echo "+ $@"
	@gofmt -s -l . | grep -v $(VENDOR) | tee /dev/stderr

lint:
	@echo "+ $@"
	@golint ./... | grep -v $(VENDOR) | tee /dev/stderr

vet:
	@echo "+ $@"
	@go vet $(shell go list ./... | grep -v $(VENDOR))

clean:
	@echo "+ $@"
	@rm -rf $(BUILDDIR)

build: clean
	@echo "+ $@"
	docker run --rm -it \
		-v $(CURDIR):/gopath/src/github.com/retr0h/rainbow \
		tcnksm/gox:1.9 \
		bash -c cd /gopath/src/github.com/retr0h/rainbow && \
			gox \
				-ldflags="$(LDFLAGS)" \
				-osarch="linux/amd64 darwin/amd64" \
				-output="$(BUILDDIR)/{{.Dir}}_{{.OS}}_{{.Arch}}"
