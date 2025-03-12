class TmuxSessionizer < Formula
  desc "Tool for opening git repositories as tmux sessions"
  homepage "https://github.com/jrmoulton/tmux-sessionizer/"
  url "https://github.com/jrmoulton/tmux-sessionizer/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "37cceae77bad373452d08b990065e7d1e8ed7b038a0af126aa4403332364530e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "36296ed7973d20aa0bb90e6b500a0136ed4f367553608f2c4dd1ef658345523f"
    sha256 cellar: :any,                 arm64_sonoma:  "53b15bddb62d79bde6f63a5cfc18910fee1e0c3f7201ee7c9dd1e0aab367ace9"
    sha256 cellar: :any,                 arm64_ventura: "f0eadc021f990f7d2db80142244a4eb679aa1125984589e50b77b6d8a6d9c2a3"
    sha256 cellar: :any,                 sonoma:        "10ee6f3d53591391cb711b5ed9876bc152a4bdaddb9488ab0bd27315f6c98fc5"
    sha256 cellar: :any,                 ventura:       "9369b6cea10b3b085a0d92fd59dba3e9951ab319e378f1b4a47e02623b67a038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e65235329ebce9f8e96e603c471bcab6b377234c6a90171b837fce670f617ecf"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"tms", shell_parameter_format: :clap)
  end

  test do
    require "utils/linkage"

    assert_match "Configuration has been stored", shell_output("#{bin}/tms config -p /dev/null")
    assert_match version.to_s, shell_output("#{bin}/tms --version")

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"tms", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
