module github.com/open-telemetry/opentelemetry-collector-contrib/exporter/awsxrayexporter

go 1.14

require (
	github.com/aws/aws-sdk-go v1.35.5
	github.com/open-telemetry/opentelemetry-collector-contrib/internal/awsxray v0.11.1-0.20200928205243-e3493cedf4b6
	github.com/stretchr/testify v1.6.1
	go.opentelemetry.io/collector v0.11.1-0.20201006165100-07236c11fb27
	go.uber.org/zap v1.16.0
	golang.org/x/net v0.0.0-20200822124328-c89045814202
	google.golang.org/grpc/examples v0.0.0-20200728194956-1c32b02682df // indirect
)
