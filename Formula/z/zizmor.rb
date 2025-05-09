class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://woodruffw.github.io/zizmor/"
  url "https://github.com/woodruffw/zizmor/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "9564db26f6e134a8f23f6d92c48a25c7cf457fed5de5ac76643cd45abf098129"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f70ae4fb964b1cf3740c0613db1f3b5fea6ca19085c47a29a492ccd81cb4f671"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d8e00f1e155a4a00464cc5ad0c2128152a58a2302d032b26b529d47cd669490"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8d76923ae416df44d70d3d6ef31b878a2ec906e66562c9dab97f96872a1c9ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "3da95aa53caa2597862f03ffd357270a47e13e27a91a7eeec12b9243912ecaa2"
    sha256 cellar: :any_skip_relocation, ventura:       "f686808a51217cd1df4f499f688c661f50fc6cf651765a2dfb5a2f9414ff0fae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dbef99a06b10f436ace04fdc5542691431122a8e539ce671c958ae89fedcdfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb26678f3ac7345ea29e4bb12b355f0ad97b8f9f1508fe764b2f265b64672c70"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zizmor", shell_parameter_format: "--completions=")
  end

  test do
    (testpath/"workflow.yaml").write <<~YAML
      on: push
      jobs:
        vulnerable:
          runs-on: ubuntu-latest
          steps:
            - name: Checkout
              uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/zizmor --format plain #{testpath}/workflow.yaml", 13)
    assert_match "does not set persist-credentials: false", output
  end
end
