// Copyright 2019, OpenTelemetry Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package jaegerthrifthttpexporter

import (
	"fmt"
	"net/url"

	"go.opentelemetry.io/collector/component"
	"go.opentelemetry.io/collector/config/configerror"
	"go.opentelemetry.io/collector/config/configmodels"
	"go.uber.org/zap"
)

const (
	// The value of "type" key in configuration.
	typeStr = "jaeger_thrift"
)

// Factory is the factory for Jaeger Thrift over HTTP exporter.
type Factory struct {
}

// Type gets the type of the Exporter config created by this factory.
func (f *Factory) Type() configmodels.Type {
	return configmodels.Type(typeStr)
}

// CreateDefaultConfig creates the default configuration for exporter.
func (f *Factory) CreateDefaultConfig() configmodels.Exporter {
	return &Config{
		ExporterSettings: configmodels.ExporterSettings{
			TypeVal: configmodels.Type(typeStr),
			NameVal: typeStr,
		},
		Timeout: defaultHTTPTimeout,
	}
}

// CreateTraceExporter creates a trace exporter based on this config.
func (f *Factory) CreateTraceExporter(
	logger *zap.Logger,
	config configmodels.Exporter,
) (component.TraceExporterOld, error) {

	expCfg := config.(*Config)
	_, err := url.ParseRequestURI(expCfg.URL)
	if err != nil {
		// TODO: Improve error message, see #215
		err = fmt.Errorf(
			"%q config requires a valid \"url\": %v",
			expCfg.Name(),
			err)
		return nil, err
	}

	if expCfg.Timeout <= 0 {
		err := fmt.Errorf(
			"%q config requires a positive value for \"timeout\"",
			expCfg.Name())
		return nil, err
	}

	return New(config, expCfg.URL, expCfg.Headers, expCfg.Timeout)
}

// CreateMetricsExporter creates a metrics exporter based on this config.
func (f *Factory) CreateMetricsExporter(
	logger *zap.Logger,
	cfg configmodels.Exporter,
) (component.MetricsExporterOld, error) {
	return nil, configerror.ErrDataTypeIsNotSupported
}
