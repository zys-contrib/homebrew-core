class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://github.com/woodruffw/zizmor"
  url "https://github.com/woodruffw/zizmor/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "b97a6b3d01d8048311a7eabd4037526f4c85e4207444d2903e92fd74085369b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a283052da5123ac6179859caef2669272b5cd41167608f59e4203dc23e8c6411"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "324701a59253d736c8fdf2591a3b0eb5023a16e05d81796bde9a8e378efec458"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "426acf0a264fa626fde65f263c04c89fa226b62a3e8cb34d3fc9e803399edc50"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4c5646d89f44f1d3de017c917f91410c03e7d9159a19424bfdfc10950d58372"
    sha256 cellar: :any_skip_relocation, ventura:       "03346631997c1add06c9ad0060bd766f3671455bfb48ef0517486d8ee9596cb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f26ec7e3c96936b5aedc407b89d871b016806b2f1a8d701b070257777b90bbae"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"action.yaml").write <<~YAML
      on: push
      jobs:
        vulnerable:
          runs-on: ubuntu-latest
          steps:
            - name: Checkout
              uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/zizmor --format plain #{testpath}/action.yaml", 13)
    assert_match "does not set persist-credentials: false", output
  end
end
