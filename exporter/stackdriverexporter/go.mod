module github.com/open-telemetry/opentelemetry-collector-contrib/exporter/stackdriverexporter

go 1.14

require (
	cloud.google.com/go/container v1.2.0 // indirect
	cloud.google.com/go/monitoring v1.4.0 // indirect
	cloud.google.com/go/trace v1.2.0 // indirect
	contrib.go.opencensus.io/exporter/stackdriver v0.13.4
	github.com/GoogleCloudPlatform/opentelemetry-operations-go/exporter/trace v0.12.0
	github.com/census-instrumentation/opencensus-proto v0.3.0
	github.com/stretchr/testify v1.7.0
	go.opencensus.io v0.23.0
	go.opentelemetry.io/collector v0.12.1-0.20201012183541-526f34200197
	go.opentelemetry.io/otel v0.12.0
	go.opentelemetry.io/otel/sdk v0.12.0
	go.uber.org/zap v1.16.0
	google.golang.org/api v0.74.0
	google.golang.org/genproto v0.0.0-20220324131243-acbaeb5b85eb
	google.golang.org/grpc v1.45.0
	google.golang.org/grpc/examples v0.0.0-20200728194956-1c32b02682df // indirect
	google.golang.org/protobuf v1.27.1
)
