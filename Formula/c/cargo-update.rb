class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v16.0.0.tar.gz"
  sha256 "50ab6c2f4c66057cdb337fe1bbb5df5b018acca88b059db0db58aa1664b44285"
  license "MIT"
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
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
