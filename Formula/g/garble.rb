class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "9fb75bad82fc89afe08bbdb26c9bbbba8766a1663f8bb585318cf363fd3eedbf"
  license "BSD-3-Clause"
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e70c335df0b8afd4bcde879f15834d091d6e0029d9deb19ba0ea868d27ba45cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e70c335df0b8afd4bcde879f15834d091d6e0029d9deb19ba0ea868d27ba45cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e70c335df0b8afd4bcde879f15834d091d6e0029d9deb19ba0ea868d27ba45cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a0ba5f077a5ac553dbdb271e3a4a2131deddffdf4194902035a2f9003393426"
    sha256 cellar: :any_skip_relocation, ventura:       "2a0ba5f077a5ac553dbdb271e3a4a2131deddffdf4194902035a2f9003393426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c26702cb6fa2e68aa1132d58d055fe5f5994b094e3e250d4a147f85624dc29c7"
  end

  depends_on "go" => [:build, :test]
  depends_on "git"

  def install
    inreplace "internal/linker/linker.go", "\"git\"", "\"#{Formula["git"].opt_bin}/git\""
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"hello.go").write <<~GO
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    GO
    system bin/"garble", "-literals", "-tiny", "build", testpath/"hello.go"
    assert_equal "Hello World\n", shell_output("#{testpath}/hello")

    expected = <<~EOS
      Build settings:
            -buildmode exe
             -compiler gc
             -trimpath true
    EOS
    assert_match expected, shell_output("#{bin}/garble version")
  end
end
