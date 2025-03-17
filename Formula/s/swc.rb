class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.11.10.tar.gz"
  sha256 "8327d3ea8c8769272465c59003ef89f372eb5f15958b51a90bd9e0d1db9a95e8"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eda6d7602f7985d8ec49b710f89f3f617b9555bccc081a8d2f1909906558b6ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b5be07a26a4c6d22b842a555ea68508bbe7804868c9966e59d8f67f000adf98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f8a4557def8c1c4a2cd8d6bf0e48d137e1ddf861c1bf29d4d430c0bbee2ec07"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc70b97641754b190a0b8fc972de25c5336309a15773ec9d6857bddd6a22ff93"
    sha256 cellar: :any_skip_relocation, ventura:       "fc387acf0a49ab1930e393cbbb72f2f2f8ba27c1c3729be2e782d01371bf2829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "759c187f0c75ccc77af734738e8c89a3408e998297029883177c77eb0164378f"
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
