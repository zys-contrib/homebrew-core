class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "edcda9a9d5d9507289c84e8527a3a2e46012eb193ba012734f6b5f60ea931491"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b118f5bad37126543a05dbbdc9deadc57e0dff6bfaa42824f9c83104796c56b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e76a338baaabdfe8f3b0e99ebce5fcec1af24796ae6bce0a557eaccea4ee70a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a46cdd1cd58b53fc6267c9a22a8d7b5757b7b25b3e14548f241b591e6129dcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "439ce0d1714e47800af2993ddc9e6e7b75e067466512280cbe24a75b88dcedb9"
    sha256 cellar: :any_skip_relocation, ventura:       "1d6282ff1456b3b7876d0806a6c09a3ff2740500b3c2de83c5f08c044069f52d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d424683938dd734ce83e69353bf03878a2d31c93472a9502775ac6ccf0d1fd09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba6b30d27e3081198fde44a2e43b3f16a260dc51d7ec1f143637835d90ceafdf"
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
