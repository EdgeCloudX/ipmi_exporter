# Copyright 2021 The Prometheus Authors
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Override the default common all.
CGO_ENABLED:=0
DOCKER_PLATFORMS=linux/arm64,linux/amd64
REGISTRY=harbor.ctyuncdn.cn/ecf-edge-dev/prometheus/ipmi_exporter
#REGISTRY=tjldockerdemo/ipmi_exporter
TAG?=0.0.1
IMAGE:=$(REGISTRY)/ipmi_exporter:$(TAG)
ifeq ($(ENABLE_JOURNALD), 1)
	CGO_ENABLED:=1
	LOGCOUNTER=./bin/log-counter
endif

package:
	docker buildx create --use
	docker buildx build  --platform $(DOCKER_PLATFORMS) -t $(IMAGE) --push .
	#docker buildx build  --platform=linux/arm64,linux/amd64 -t $(IMAGE) --push.

build: $(PKG_SOURCES)
	CGO_ENABLED=$(CGO_ENABLED) GOOS=linux GO111MODULE=on go build  -o ipmi_exporter