class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.62.1.tar.gz"
  sha256 "49191c40fb4c96c9316ded909571553b0f773101a842519e0b85af313dceea31"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f2acd995be35d26f3bf8041a4cb19c1acf3a6aa282aeff7c5919c6f800069f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "535cced6a23ea1e219f6ddb7edec36fdb81b66905525b23c6cf8fdafad5e493c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbfd69a3c5b7ba06133bc1152a6a383e51e3e3a5789fc77b375115abb9ac0bb7"
    sha256 cellar: :any_skip_relocation, sonoma:         "67a283b560809b92dfbc69576de79eeac81b2ce3b75ddf213ba714e92050841a"
    sha256 cellar: :any_skip_relocation, ventura:        "8e7788a651082eb9e51b22b999c699416ae4d2b8105e2f60a349bc1cc33ad1c6"
    sha256 cellar: :any_skip_relocation, monterey:       "335db42c732478bf73a4f9227f6de35a2c18e12f57a0f81924aaee3063aa365a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd248cdbfcc98dcaf9694190bd6da1ccf625197b05b68e51456416c1ebb91e88"
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
