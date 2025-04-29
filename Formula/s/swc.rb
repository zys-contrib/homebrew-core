class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.11.23.tar.gz"
  sha256 "3a30d0f34383735c59b57d7d790c0ace6c18db7f012b986eea36510dff29dab5"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fc5431a4db564cfbb2e76ca17d989bea21b8fdfc1ec23e788a152b15341131a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b8376e9df876e110fa95c975f545312c1b0d33ff2993623ec92e9ffb91f34b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "589da8fd56eb80b4bada8219b3dc1266a6f7d312a9267658e9ab290c801dbd97"
    sha256 cellar: :any_skip_relocation, sonoma:        "20c6d349c6002fc59f92c3fd6dd816ad4939892fecf576af755da3e8c6b48b45"
    sha256 cellar: :any_skip_relocation, ventura:       "4a2c090481566fb6d8f66d2096cd4c0c37d617b478d56d7796eda7e04470cb84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f49c108b42c453cfd106fed6a75e0dcc6dca85a83751e2c4b4239951433498ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e53cd960e9cc1c09d72e3f31e5838b8d400544781325b950392cfe13e9fe318"
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
