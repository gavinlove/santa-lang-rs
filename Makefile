IMAGE = rust:1.68.2-bullseye
DOCKER = docker run --rm -e CARGO_HOME=/app/.cargo -v $(PWD):/app -w /app

.PHONY: shell
shell:
	@$(DOCKER) -it $(IMAGE) bash

.PHONY: can-release
can-release: lint test

.PHONY: lint
lint:
	@$(DOCKER) $(IMAGE) bash -c "\
		rustup component add rustfmt clippy && \
		cargo fmt -- --check && \
		cargo clippy -- -D warnings"

.PHONY: test
test: test/lang test/cli test/wasm

.PHONY: test/lang
test/lang:
	@$(DOCKER) $(IMAGE) cargo test --package santa-lang --verbose

.PHONY: test/cli
test/cli:
	@$(DOCKER) $(IMAGE) cargo build --bin santa-cli --verbose
	@$(DOCKER) $(IMAGE) cargo test --bin santa-cli --verbose

.PHONY: test/wasm
test/wasm:
	@wasm-pack test --node wasm

.PHONY: fmt
fmt:
	@$(DOCKER) -it $(IMAGE) bash -c "rustup component add rustfmt && cargo fmt"

.PHONY: lambda/build
lambda/build:
	@$(DOCKER) -e BIN=santa-lambda rustserverless/lambda-rust

.PHONY: lambda/serve
lambda/serve:
	@docker run --rm -it \
		-e DOCKER_LAMBDA_STAY_OPEN=1 \
		-e _HANDLER=fibonacci.handler \
		-p 9001:9001 \
		-v $(PWD)/target/lambda/release/santa-lambda:/opt/bootstrap \
		-v $(PWD)/lambda/fixtures:/var/task \
		lambci/lambda:provided.al2

.PHONY: php-ext/build
php-ext/build:
	@docker build -t local/santa-php-ext-build - < php-ext/build.Dockerfile
	@$(DOCKER) local/santa-php-ext-build bash -c "cargo build --package santa-php-ext --release"

.PHONY: php-ext/test
php-ext/test:
	@docker build -t local/santa-php-ext-build - < php-ext/build.Dockerfile
	@$(DOCKER) local/santa-php-ext-build bash -c "php -dextension=./target/release/libsanta_lang.so php-ext/fixtures/test.php"

.PHONY: docs/serve
docs/serve:
	@docker run --rm -it -p 8000:8000 -v $(PWD):/docs squidfunk/mkdocs-material

.PHONY: docs/build
docs/build:
	@docker run --rm -v $(PWD):/docs squidfunk/mkdocs-material build --clean --site-dir site --verbose

cli/build/%:
	@$(DOCKER) joseluisq/rust-linux-darwin-builder:1.68.2 \
		sh -c "cargo build --release --bin santa-cli --target $*"
