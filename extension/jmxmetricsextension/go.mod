module github.com/open-telemetry/opentelemetry-collector-contrib/extension/jmxmetricsextension

go 1.14

require (
	github.com/shirou/gopsutil v2.20.9+incompatible
	github.com/stretchr/testify v1.6.1
	go.opentelemetry.io/collector v0.12.1-0.20201012183541-526f34200197
	go.uber.org/atomic v1.7.0
	go.uber.org/zap v1.16.0
)

replace github.com/open-telemetry/opentelemetry-collector-contrib/internal/common => ../../internal/common
