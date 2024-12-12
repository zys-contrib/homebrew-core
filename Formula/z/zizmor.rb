class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://github.com/woodruffw/zizmor"
  url "https://github.com/woodruffw/zizmor/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "d6477e8e57bca79c7b4b92c98baf8af268fe66894bcb36036e0e555cb4323d44"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c949eaaa872686481a1caf1783a8219571a53cdd0bb4950990b07ce20a33d29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "500f5b59b5cac7ec5b57169a30b322b56555124de5479bcbef8c45e53ca426f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "857a7811fc40a3b8ba23b7a6586ad424dfa304e9dde06cf2ec767ca2ce2bbfc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba9f1e82831c5da1d99fd39e47687e53f88ddc30a239bb2ca9836c8c7c3c63bb"
    sha256 cellar: :any_skip_relocation, ventura:       "c70532bd304b97bf50cf983ea581d67dc14fd99ef1da6f9bd18bb0f86e054cb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e40b05781f91ab2fba6dfa33fea4f24ce7c149226777b0354713ce34fb778c52"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

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
