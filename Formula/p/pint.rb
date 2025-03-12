class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.71.1.tar.gz"
  sha256 "a8300994a34342f5e88ad2813ffa86ca6b3b0f9d97af69ccc439e5233776591d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bd98a6f09105f5b410196f0925914a01819f899c8b89d72302bd95564dcf1a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f108886e0b4620f987bfb64589d08653154f11e658cf06f6d9e760bf3cc1c83e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7eb65566d66365239f02e4fe08f15271ad85eecce4188da432e1354dd63c1a44"
    sha256 cellar: :any_skip_relocation, sonoma:        "f595712706f5110888239c83b1ad6cf5669b6c52eda2df1611168e1c2bbbdec9"
    sha256 cellar: :any_skip_relocation, ventura:       "776d2086fdff962c17c6077ac14ed35e5a179d5b732d1dcd3001b9de7b60c192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10118aac79da36a5f434c3d410d6063322495f8848f2e3011c7f89288d78e9c9"
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
