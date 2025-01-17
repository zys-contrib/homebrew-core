class Pkgx < Formula
  desc "Standalone binary that can run anything"
  homepage "https://pkgx.sh"
  url "https://github.com/pkgxdev/pkgx/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "853f61de9b5ff7507346e47f9d6b7de361253eff95911641838230e380fca9e1"
  license "Apache-2.0"
  head "https://github.com/pkgxdev/pkgx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acc706537e61dd2af1820c050d597391aa2ab77f564a8cde4dfb5a9518e219c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05431a3bfe321785575475f0a965482452b1178f136081d2ff74d33c13128d55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "224a1ffe0c053f6cb98d113d8d16fe94edd397600da7d07625e132bc6ce3e72b"
    sha256 cellar: :any_skip_relocation, sonoma:        "914f6a489d66b9821b1b22a78848692a1ba7cf93c7f070f42a1d7f2547b69a89"
    sha256 cellar: :any_skip_relocation, ventura:       "b777cd91d17e9a7f0a3ea9415c44db1e1c5c9692c1c66520d0f5cd6b74fb2f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7158dc75ccab6c6fafcafeff6b8d976afbc1ee478bdab4e6981fde060b402b83"
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
