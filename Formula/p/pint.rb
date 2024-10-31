class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.67.2.tar.gz"
  sha256 "3a78b0d0b6d9656f26485125dede9110295d1dedd34302408e63766c91062ae3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68ee71b09b1326f6f60316581cc7472c96d0f647c07e1181de27c7b283c7e51d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68ee71b09b1326f6f60316581cc7472c96d0f647c07e1181de27c7b283c7e51d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68ee71b09b1326f6f60316581cc7472c96d0f647c07e1181de27c7b283c7e51d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb3741d05739e8c44e04e374e8f270f39df4a2e759da1ba491dcc84fb36fcee7"
    sha256 cellar: :any_skip_relocation, ventura:       "fb3741d05739e8c44e04e374e8f270f39df4a2e759da1ba491dcc84fb36fcee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e803f731b0292dfca57bfc22a2cfaa76da1cd758bafc335eccd0046211d517d2"
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
    (testpath/"test.yaml").write <<~EOS
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
    EOS

    cp pkgshare/"examples/simple.hcl", testpath/".pint.hcl"

    output = shell_output("#{bin}/pint -n lint #{testpath}/test.yaml 2>&1")
    assert_match "level=INFO msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=INFO msg=\"Problems found\" Warning=6", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end
