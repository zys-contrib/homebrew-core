class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "73daba7f14cab3762ee3c86befbe6876dc6c7856d6908fb69de12545f436f1d7"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fa0021a863463c440902e155a56007c899896cd44190ea6de467c51c3ad8c1ba"
    sha256 cellar: :any,                 arm64_sonoma:  "66f3579ac1a36d75108f94d66180695079e4bfab2a29c572aec41235e4177099"
    sha256 cellar: :any,                 arm64_ventura: "b569729fa5815c0941de03070b05fac4b2698a39fc453ef1f0ff741046cd934d"
    sha256 cellar: :any,                 sonoma:        "c58880db2ad9babb20bc542cbe68a6ee2797122be33ccf00108cf3a42ec6b482"
    sha256 cellar: :any,                 ventura:       "98e459f3940abd399351db47b02951b37e5949a9d1cee24f7b16a9ed3dff687f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bc009d806e87ac07ef58d90077d03eeae0eca4be478bb6d71c692c3124a350c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "905a8fe88f96d9b52b70bfe0aa3411eec9b631249e7ec4e771bc52bcf3c5b9a9"
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
