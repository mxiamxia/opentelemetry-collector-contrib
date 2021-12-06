module github.com/open-telemetry/opentelemetry-collector-contrib/exporter/jaegerthrifthttpexporter

go 1.14

require (
	github.com/apache/thrift v0.15.0
	github.com/census-instrumentation/opencensus-proto v0.3.0
	github.com/google/go-cmp v0.5.6
	github.com/jaegertracing/jaeger v1.29.0
	github.com/stretchr/testify v1.7.0
	go.opentelemetry.io/collector v0.12.1-0.20201012183541-526f34200197
	go.uber.org/zap v1.19.1
	google.golang.org/protobuf v1.27.1
)
