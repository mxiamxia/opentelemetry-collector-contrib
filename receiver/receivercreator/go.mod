module github.com/open-telemetry/opentelemetry-collector-contrib/receiver/receiver_creator

go 1.14

require (
	github.com/census-instrumentation/opencensus-proto v0.2.1
	github.com/open-telemetry/opentelemetry-collector v0.3.1-0.20200414190247-75ae9198a89e
	github.com/open-telemetry/opentelemetry-collector-contrib/extension/observer v0.0.0
	github.com/spf13/viper v1.6.2
	github.com/stretchr/testify v1.4.0
	go.uber.org/zap v1.13.0
)

replace github.com/open-telemetry/opentelemetry-collector-contrib/extension/observer => ../../extension/observer
