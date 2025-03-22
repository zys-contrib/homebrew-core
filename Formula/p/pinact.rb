class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "1e448da8a4b2be37f6a27809717840f47e58efca44e2883a7f7a39f535b59e8c"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91e4f9d294c595ce6d37f5cfbcb8e716e1f717c2b39ccffccffb7b1e0f86552f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91e4f9d294c595ce6d37f5cfbcb8e716e1f717c2b39ccffccffb7b1e0f86552f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91e4f9d294c595ce6d37f5cfbcb8e716e1f717c2b39ccffccffb7b1e0f86552f"
    sha256 cellar: :any_skip_relocation, sonoma:        "eda1861b8fe56e71c22049e0d733b2052a49353899cd867e7622a23366fa7d47"
    sha256 cellar: :any_skip_relocation, ventura:       "eda1861b8fe56e71c22049e0d733b2052a49353899cd867e7622a23366fa7d47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05ac2ad6eff3c1223f6c8becc11c345de37a042973587bb6a6ef105fa37795fb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pinact"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pinact --version")

    (testpath/"action.yml").write <<~YAML
      name: CI

      on: push

      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v3
            - run: npm install && npm test
    YAML

    system bin/"pinact", "run", "action.yml"

    assert_match(%r{.*?actions/checkout@[a-f0-9]{40}}, (testpath/"action.yml").read)
  end
end
