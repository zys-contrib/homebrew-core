class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.73.5.tar.gz"
  sha256 "33431de4f75681b0ba2fb5134a4ae57be4012b336c49f69972e2ed423c22bd08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2db2290a87cc128939436885c077f49fdf0c9e9a5cca0c829662f4875f1783cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b1cd75b47d36671e8ad4f9ce51359ba48b001a99b940a7da9eced631bf64efc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "363c6b553d6e85543ff8677b08288b35444d32334c68dd9263b5b11abe7e8f93"
    sha256 cellar: :any_skip_relocation, sonoma:        "020e52fd8c4c8c4bad8093787c6a0c276f55e66fdf65c03379e26e6719f92101"
    sha256 cellar: :any_skip_relocation, ventura:       "f078b2ed1e1e2143d7a3f1e4859321ddffaeafae8906acf7a29068627bb7263a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5f3417767db8a03bde3757a4951ff6e206e531efb06b3f2291a2cc4672ec14a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pint"

    pkgshare.install "docs/examples"
  end

  test do
    (testpath/"test.yaml").write <<~YAML
      groups:
      - name: example
        rules:
        - alert: HighRequestLatency
          expr: job:request_latency_seconds:mean5m{job="myjob"} > 0.5
          for: 10m
          labels:
            severity: page
          annotations:
            summary: High request latency
    YAML

    cp pkgshare/"examples/simple.hcl", testpath/".pint.hcl"

    output = shell_output("#{bin}/pint -n lint #{testpath}/test.yaml 2>&1")
    assert_match "level=INFO msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=INFO msg=\"Problems found\" Warning=6", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end
