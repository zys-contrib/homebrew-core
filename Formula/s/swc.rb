class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "32004452c5130f52121050a0246854bc913ce874a0115c026d314c77702e38c7"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbf84fcd27f158f0669f46e0f5b0851d4b44a712a08a37490ae2ac61219d5ac7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "266b79e4e9a3a690c7f8f09cbe698e5f756b74e69511587c517c6dccde09fc69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef35a93a433e5029532faeb69206cc8fbff93a38fdb0b036b7e595e1d4af39e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "76241852b49384fbf1834b5fca99ea8fd92c750b666a32b8aedb397b6eb8e72e"
    sha256 cellar: :any_skip_relocation, ventura:       "b0841639838f4adbb927a3be74dd96aaa940ff68321833f363621e6f4784625c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "201e638d8f4c250be120cdc1abef7abafe01efbd69a6323c8911ea0a030bbcd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e985064eff48432dc782292020aabed21f69ce7d6593ca6fe9c1a1adcb005c0a"
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
