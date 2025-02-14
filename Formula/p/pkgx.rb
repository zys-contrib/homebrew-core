class Pkgx < Formula
  desc "Standalone binary that can run anything"
  homepage "https://pkgx.sh"
  url "https://github.com/pkgxdev/pkgx/archive/refs/tags/v2.3.tar.gz"
  sha256 "140157a8042f410792e4f4f670d85c72e80f12abd0b35bcaba458113475a5e1c"
  license "Apache-2.0"
  head "https://github.com/pkgxdev/pkgx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e48efc98c368b3ba23aee5c2c484d6c4337580bce9b187dfd9667038f812a661"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d0169cc9bdd633d9f934e84ac40474bd3b398ceeace4ef71631ace50caf2439"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d0cf95a04e53329340499412ebb337fbc0ed2c1c04befa8e06448be622081fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "77ade1db45485dd13f56d498a2f4afb829e7577d099587f45e36a64b608c2ef5"
    sha256 cellar: :any_skip_relocation, ventura:       "6dbec3d73cee9c2d5e62aca160cc209693a75bc8885171221bb62f9c08b0c620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1c2005acbc49c8d32f7d186a46147d153272f11cd2793cc639da2325158cd2c"
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
