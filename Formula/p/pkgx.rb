class Pkgx < Formula
  desc "Standalone binary that can run anything"
  homepage "https://pkgx.sh"
  url "https://github.com/pkgxdev/pkgx/archive/refs/tags/v2.4.tar.gz"
  sha256 "30fa5903eb77658b9df007e1f422e4788513992400925f843c705b5f4b91a43c"
  license "Apache-2.0"
  head "https://github.com/pkgxdev/pkgx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6385b1d94156b248676475ce628631ceaead3d7b8fffe682c55c2984d1361381"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21e0b7ba45949507692878ef90eeda2e7dbe1c5e66aabdd252d6156a3e8db1a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe8646475d992c9ff4dd173fa598845b53a5a73fb23aac593d25fc10be66e41f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b3b168187d9e4f81116aacf3209d23e52fdc13bb87428e03166bd121528f163"
    sha256 cellar: :any_skip_relocation, ventura:       "619c91ec849a2d893db2ea4c647dc561123baf6de814b0036da96cd81929ba08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e180d3bdf7cc8808cca1acda63d848ce018a697edd484d11b5b3f59aa3df5ed"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"main.go").write <<~GO
      package main

      func main() {
        println("Hello world")
      }
    GO
    assert_match "1.23", shell_output("#{bin}/pkgx go@1.23 version")
    assert_match "Hello world", shell_output("#{bin}/pkgx go@1.23 run main.go 2>&1")
  end
end
