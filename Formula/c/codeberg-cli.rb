class CodebergCli < Formula
  desc "CLI for Codeberg"
  homepage "https://codeberg.org/Aviac/codeberg-cli"
  url "https://codeberg.org/Aviac/codeberg-cli/archive/v0.4.7.tar.gz"
  sha256 "a8d1356faab84076f14977652dabbfcad4411f49beb4d11a1bc0ee8936bd1d6c"
  license "AGPL-3.0-or-later"
  head "https://codeberg.org/Aviac/codeberg-cli.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"berg", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/berg --version")

    assert_match "Field    ┆ Source   ┆ Value", shell_output("#{bin}/berg config info")

    output = shell_output("#{bin}/berg repo info Aviac/codeberg-cli 2>&1")
    assert_match "Couldn't find login data", output
  end
end
