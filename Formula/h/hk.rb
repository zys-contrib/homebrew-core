class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "753cb1173713a47eba7e90f9e43bfab120596cdd1c47ad306e3f7823460dd898"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5c03acd4ebdfd7ba980e208eca8038547ccdaa8e5d4d9fb15f43f38f1a836c42"
    sha256 cellar: :any,                 arm64_sonoma:  "da7ba6806b9ffe20d1808eb08491ca38f34870a10cdd375edfa33cefc9cd1b65"
    sha256 cellar: :any,                 arm64_ventura: "3cea4b39d7ce80948499683e92a8b240e042dfa7bc0c595789c82470930f1839"
    sha256 cellar: :any,                 sonoma:        "b854637c5eaec920b7c6caeaab8682f14a4926ee2290e8b70aea0061bed57d25"
    sha256 cellar: :any,                 ventura:       "1c334becb758f6f8695de1576ec03080e0aa69385ba7c398e1c6892f805ac76d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27dbcf3acf3176cd8eb9d7a8dce6ed5fb9f9d25f797d30e5ba18a7da81855584"
  end

  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "pkl"
  depends_on "usage"

  uses_from_macos "zlib"

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"hk", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hk --version")

    (testpath/"hk.pkl").write <<~PKL
      amends "package://github.com/jdx/hk/releases/download/v#{version}/hk@#{version}#/Config.pkl"

      linters {
          ["cargo-clippy"] {
              glob = new { "*.rs" }
              check = "cargo clippy -- -D warnings"
              fix = "cargo clippy --fix --allow-dirty"
          }
          ["cargo-fmt"] {
              glob = new { "*.rs" }
              check = "cargo fmt -- --check"
              fix = "cargo fmt"
          }
      }

      hooks {
          ["pre-commit"] {
              ["cargo-clippy"] = new Fix {}
              ["cargo-fmt"] = new Fix {}
          }
      }
    PKL

    system "cargo", "init", "--name=brew"
    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all -v 2>&1")
    assert_match(/cargo-fmt\s* ✓ done/, output)
  end
end
