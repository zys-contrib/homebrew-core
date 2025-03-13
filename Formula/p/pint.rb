class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.71.3.tar.gz"
  sha256 "1a73af2866594f92b20a3c47a2a64f1cce833748194012c4d7cb27a59825ed91"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2df93f9be0df11c9be89d280b8589ea8bf4cc200425b8efee9d62128b8c8333c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0335319f334912692f01b0d2fe57af10ad84cf73a1d5447551d71a072c2f9ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f69f9dd87bec62d3c04137e5979e7001060c8f89b3dbf42aabe9a417c296c5cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dddad4ef53fcf2e2703bc951c3ebcd30a3798d103d69d188885ab912f66054e"
    sha256 cellar: :any_skip_relocation, ventura:       "5ed09a9bf14340a30cf25179defd8727f1c0ec0924f92f9b724cfb1ccea2986d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96540e1354aab7740d4365716940f7ced86154b4cd84f82688ad0c9b987027f6"
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
