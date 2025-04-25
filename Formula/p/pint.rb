class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.73.4.tar.gz"
  sha256 "cd38034a38e39526327dbe4b0c92b272f167cbe9ea3747dcc971e1b41b344257"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b93a61bad8cb5387dd3ef0656d4ea782e1187e821980f787b2892296e8b23d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4757332d07472fd9ae55dda18bfb36a786308dfae488eb6dc7cef1ec7e71c438"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e69e6203ce651d8d15fd6a1f9fdfa0c4d20bea92850654587e19ae6e8d83155"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f6d9272eee87597863a4ca6b57513f1cf5e024b9c97e0352e8890a037d0c559"
    sha256 cellar: :any_skip_relocation, ventura:       "bfb60bbb6cd55997824877ff312032ab1dfca90edd39dd10b9e48d258a560a28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35e9e573892b68e307dc021e2625c73e7648694e14fe2a9c7ef9e4e34b6ace6e"
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
