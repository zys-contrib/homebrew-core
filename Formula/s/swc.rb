class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.10.5.tar.gz"
  sha256 "2628ed727c788e1169badf68b425c9daf3c9fd23b1c0f4794cb56619b6ca6c6d"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0ce2eedefd31e96e3be28465555011cbd60315d94aeb01176aa8fa65a62fa4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38c12168775f115ec05628e2a93f52f86ee2b68fe8923b0f9383fd4537243364"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17445859039fca7fed3e0a786c4ffd82b4a17c5df008fd4892f4b597ccfab8a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "144c679cdd08d041065f6febacaa2fa0cd684ba891c4775132b7dbfe674c9482"
    sha256 cellar: :any_skip_relocation, ventura:       "c3480c3c62a0c751b450dfebad13de1f056190d0584891df308bc6d38af3a078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d50d86a615ecc5a1278ba0ab69a5189c7f67bc6862ee8156f4fe0fd231c8f6de"
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
