# =============================================================================
# eriktonon/docker-images — Build-to-Manage Operational Makefile
# =============================================================================

REGISTRY ?= eriktonon

MODERN_IMAGES := \
	php:8.4-fpm-alpine:php/8.4-fpm-alpine \
	php:8.4-apache-bookworm:php/8.4-apache-bookworm \
	php:8.3-fpm-alpine:php/8.3-fpm-alpine \
	php:8.2-fpm-alpine:php/8.2-fpm-alpine \
	postgres:17-alpine:postgres/17-alpine \
	postgres:16-alpine:postgres/16-alpine \
	mysql:8.4-lts:mysql/8.4-lts \
	mysql:8.0:mysql/8.0 \
	phpmyadmin:5.2:phpmyadmin/5.2

.PHONY: help build-modern push-modern

help:
	@echo "Targets:"
	@echo "  make build-modern   - Build all modern LTS container images (PHP 8.2-8.4, PG 16-17, MySQL 8.0-8.4, phpMyAdmin 5.2)"
	@echo "  make push-modern    - Push all modern LTS container images to Docker Hub ($(REGISTRY)/*)"

build-modern:
	docker build -t $(REGISTRY)/php:8.4-fpm-alpine php/8.4-fpm-alpine
	docker build -t $(REGISTRY)/php:8.4-apache-bookworm php/8.4-apache-bookworm
	docker build -t $(REGISTRY)/php:8.3-fpm-alpine php/8.3-fpm-alpine
	docker build -t $(REGISTRY)/php:8.2-fpm-alpine php/8.2-fpm-alpine
	docker build -t $(REGISTRY)/postgres:17-alpine postgres/17-alpine
	docker build -t $(REGISTRY)/postgres:16-alpine postgres/16-alpine
	docker build -t $(REGISTRY)/mysql:8.4-lts mysql/8.4-lts
	docker build -t $(REGISTRY)/mysql:8.0 mysql/8.0
	docker build -t $(REGISTRY)/phpmyadmin:5.2 phpmyadmin/5.2

push-modern: build-modern
	docker push $(REGISTRY)/php:8.4-fpm-alpine
	docker push $(REGISTRY)/php:8.4-apache-bookworm
	docker push $(REGISTRY)/php:8.3-fpm-alpine
	docker push $(REGISTRY)/php:8.2-fpm-alpine
	docker push $(REGISTRY)/postgres:17-alpine
	docker push $(REGISTRY)/postgres:16-alpine
	docker push $(REGISTRY)/mysql:8.4-lts
	docker push $(REGISTRY)/mysql:8.0
	docker push $(REGISTRY)/phpmyadmin:5.2
