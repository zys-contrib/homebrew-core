class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "05d6747419f86f9e55069784915a443a9248e3c2fc98c8b148d8e990d8b1cf34"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "06e956420242b57c4f88b39d6f2a5e4c9861263ab662173476e4b8e051fd8d3c"
    sha256 cellar: :any,                 arm64_sonoma:  "751024219af1fef5cae8ee22568c7f0325db065b2345ec426c6314cf88da27fd"
    sha256 cellar: :any,                 arm64_ventura: "97f832d0e6a38b6e4343e8eac0cf9753c3423d6d16372072b70586012d6cdde6"
    sha256 cellar: :any,                 sonoma:        "68b94b4af64049821a1c2c616cd821b13900be1eeb431d832cad89ce43673690"
    sha256 cellar: :any,                 ventura:       "e529d0a489ce384600e77998ec80820a6456c0e1d7518cb0b71abc2f050678a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "844465931e28caf61027d40d6a5d3f1325cb63adb8eda28f71aa142fb16f46ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "725e18a1d47750bdf0bf04b46b534759865f7c9cd07e03a7b9060a5505c53b21"
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
      import "package://github.com/jdx/hk/releases/download/v#{version}/hk@#{version}#/builtins.pkl"

      hooks {
        ["pre-commit"] {
          steps = new { ["cargo-clippy"] = builtins.cargo_clippy }
        }
      }
    PKL

    system "cargo", "init", "--name=brew"
    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end
