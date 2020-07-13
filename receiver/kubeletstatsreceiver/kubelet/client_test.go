// Copyright 2020, OpenTelemetry Authors
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

package kubelet

import (
	"crypto/tls"
	"crypto/x509"
	"io"
	"net/http"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestClient(t *testing.T) {
	tr := &fakeRoundTripper{}
	baseURL := "http://localhost:9876"
	client := &tlsClient{
		baseURL:    baseURL,
		httpClient: http.Client{Transport: tr},
	}
	require.False(t, tr.closed)
	resp, err := client.Get("/foo")
	require.NoError(t, err)
	require.Equal(t, "hello", string(resp))
	require.True(t, tr.closed)
	require.Equal(t, baseURL+"/foo", tr.url)
	require.Equal(t, 1, len(tr.header))
	require.Equal(t, "application/json", tr.header["Content-Type"][0])
	require.Equal(t, "GET", tr.method)
}

func TestDefaultTLSClient(t *testing.T) {
	endpoint := "localhost:9876"
	client := defaultTLSClient(endpoint, true, &x509.CertPool{}, tls.Certificate{}, nil)
	require.NotNil(t, client.httpClient.Transport)
	require.Equal(t, "https://"+endpoint, client.baseURL)
}

var _ http.RoundTripper = (*fakeRoundTripper)(nil)

type fakeRoundTripper struct {
	closed bool
	header http.Header
	method string
	url    string
}

func (f *fakeRoundTripper) RoundTrip(req *http.Request) (*http.Response, error) {
	f.header = req.Header
	f.method = req.Method
	f.url = req.URL.String()
	return &http.Response{
		Body: &fakeReadCloser{
			Reader: strings.NewReader("hello"),
			onClose: func() {
				f.closed = true
			},
		},
	}, nil
}

var _ io.ReadCloser = (*fakeReadCloser)(nil)

type fakeReadCloser struct {
	io.Reader
	onClose func()
}

func (f *fakeReadCloser) Close() error {
	f.onClose()
	return nil
}
