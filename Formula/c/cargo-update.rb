class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v16.1.0.tar.gz"
  sha256 "9173e0354eea95f5f6419c710467710b88c0b0a4562953bdfc4a82bfb125b8e1"
  license "MIT"
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1506d6731e67f9668912ee05124cbc1e5dc8f8f9264a8279b15afb86beb0b074"
    sha256 cellar: :any,                 arm64_sonoma:  "2472f0e080ea5498a9640c7208b2976b387f215b15dc7ec63ce0bb2669fc7d7a"
    sha256 cellar: :any,                 arm64_ventura: "3da0e37d79d0f0119e3a62005cd7f7565c7772f07ebb3755ff258a98f88ed43a"
    sha256 cellar: :any,                 sonoma:        "5b3056af65e3f2a791588b88bc2eed97c1d9c732b0f91eea59d73bc0b3f696a4"
    sha256 cellar: :any,                 ventura:       "e2d7579199c484930578c471ca2d5f2cb228dd1c5dde114a5552ee9ee95c8015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cc6e09d23c9db33efe7b3dc64133067c3111afe97b80f11e3a8fed0023d38f9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    assert_match version.to_s, shell_output("cargo install-update --version")

    output = shell_output("cargo install-update -a")
    assert_match "No packages need updating", output
  end
end
