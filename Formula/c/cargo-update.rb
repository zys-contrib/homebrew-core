class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v16.0.0.tar.gz"
  sha256 "50ab6c2f4c66057cdb337fe1bbb5df5b018acca88b059db0db58aa1664b44285"
  license "MIT"
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2ff92e4df4e653b3321277e42b7141a1719c67a051e0c45e45d89911d5c04192"
    sha256 cellar: :any,                 arm64_sonoma:  "eec24dd052eedc88109119bf77a9e54420767e488ee6dbd6762e0e0897ededce"
    sha256 cellar: :any,                 arm64_ventura: "cb1fc2fa67c9b1dda6e801c50c6e68cb1e9bcb7c8b6886979562aeb4e4f4edca"
    sha256 cellar: :any,                 sonoma:        "89264ed913452f134aeba5d1c58e8a29bd4e4f75808c5439395c8ddaad3cdd02"
    sha256 cellar: :any,                 ventura:       "5fa331e905ebaff4f74780ab20fe70d1a8ab6a5da3fde7abb7b5abedeb2f524a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d7a296c94773835194c18b14d75b0935c6d4d9292774107c5078c831fe8144b"
  end

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
