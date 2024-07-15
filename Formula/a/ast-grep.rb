class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.25.1.tar.gz"
  sha256 "40c197c51235490963da6774c5c3f2d726c22d61eec8ff4bc412ace32da8f60f"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26a3b031526ddeb59d61eeeaa0a65e88f4da454a0532c4e921a7a76ddf7c4a08"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dabe7a65d6a553b0c0eab7ee6ebd23ba7fbd995fa70a5b5b4ecb831aa1def99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6aa096ef2e6e9cd8c6aeb95f5c23a2562a449d7ce976e9ac13a9efd8437dc1a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6aacc454b35f3a6f4f0fb2c62e46b054433380d2b9d1f9f4a5428628365651d"
    sha256 cellar: :any_skip_relocation, ventura:        "cfc12ee5e16f03115037bb3f6bc3ef71c121d0138052dffdc107a0731d73aa6d"
    sha256 cellar: :any_skip_relocation, monterey:       "82e1ff093f99ccc7deda2bdd70af89e99637a34a74f3cf41a5cd9df27b1f0c23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6307a27626ae83d24a8f0f75aefc0d36adf2f04c064a631ba0165f06f08d8277"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
