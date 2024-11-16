class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://github.com/woodruffw/zizmor"
  url "https://github.com/woodruffw/zizmor/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "11d7ee3fce3040a4596f0cf615f1bb524136976f7e32705a9d6ffcebcb260f94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08220377a75fb18208f49a2cc8aca02f2c5c1364b0f86492dc48cd1240e3eeb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38188ba2bd2cabb9a141faac13c318f4f288d5f45f21bfa5812a54a86c10feb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fedbf4a356f958d935b0602587093de5fe072a62068d0e9b1068ad51be942c99"
    sha256 cellar: :any_skip_relocation, sonoma:        "c397394d76f0a06d4261c148dbb64b2e0dabcecb5c5e8d20c178bd10112bdd39"
    sha256 cellar: :any_skip_relocation, ventura:       "7e92fa94450aecbf77de85210a0100ada23199b92c69bc0e6152e213b286f34b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8772e59474fbc4df20cf5c609605b48b16641e21a9bf18218b62e160ce8285b"
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
