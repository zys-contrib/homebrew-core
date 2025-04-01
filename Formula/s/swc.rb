class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.11.16.tar.gz"
  sha256 "a2231038f822515ae011a788fad1b92983740a42292ba925abc3776ea321c43a"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "858a53ff4e92d8a16564ab7d31a93ac933d1442c2439fbb1b19061e005c01e4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8f0d4797e691729eb71ea1b224b467951444089511d93b3d8b37ecdf638effa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1f5b429dd45189830efd00d08fcc7cec07eb67709eeea43e8086646a7bdbe6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d114f5a8e6d3f34e5fc69de078afc5b4c8bdbeef441ede299f5063d3e8c0ffd"
    sha256 cellar: :any_skip_relocation, ventura:       "caf040cafedc29e46a36cc4b22f5d07578318e75f0e098faa0e659762f0c93b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "968803dcc6351f2a96d525f7a27298ca4194ee750d398506b0324ddcbe299f5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8164afa4e1c550752c9ab00193e500a49e66f7c9e1e1ad4ff24eb9239335ef76"
  end

  depends_on "rust" => :build

  def install
    # `-Zshare-generics=y` flag is only supported on nightly Rust
    rm ".cargo/config.toml"

    system "cargo", "install", *std_cargo_args(path: "crates/swc_cli_impl")
  end

  test do
    (testpath/"test.js").write <<~JS
      const x = () => 42;
    JS

    system bin/"swc", "compile", "test.js", "--out-file", "test.out.js"
    assert_path_exists testpath/"test.out.js"

    output = shell_output("#{bin}/swc lint 2>&1", 101)
    assert_match "Lint command is not yet implemented", output
  end
end
