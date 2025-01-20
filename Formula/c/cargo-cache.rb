class CargoCache < Formula
  desc "Display information on the cargo cache, plus optional cache pruning"
  homepage "https://github.com/matthiaskrgr/cargo-cache"
  url "https://github.com/matthiaskrgr/cargo-cache/archive/refs/tags/0.8.3.tar.gz"
  sha256 "d0f71214d17657a27e26aef6acf491bc9e760432a9bc15f2571338fcc24800e4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/matthiaskrgr/cargo-cache.git", branch: "master"

  depends_on "rust" => :build
  depends_on "rustup" => :test

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

    output = shell_output(bin/"cargo-cache")
    assert_match "0 installed binaries:", output

    assert_match version.to_s, shell_output("#{bin}/cargo-cache --version")
  end
end
