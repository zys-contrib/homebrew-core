class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "22a1696ce880b34ca5ff949b6b5a42d4e370502e0b40b59eaa679eae13e45363"
  license "BSD-3-Clause"
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42ded605b7065c9de782eb5460d646e13672d73b548f98020b43f383e1e3cfb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15303a49f8e88b4ae4e3f4324fe586787bfd3182870273748d1c3ef307e64712"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf2b67c017a85ba897aca5b7ffcf9b897f4c4543c9d8cb642d53750a588641de"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3da8a4ddd622cd889a1584c911cfc075628b46d9e20eb251afe8e22857e569c"
    sha256 cellar: :any_skip_relocation, ventura:        "27f77707c30eeb820bd4b45263899d526e6f935450274f20402e6db8fe480609"
    sha256 cellar: :any_skip_relocation, monterey:       "3022aaf2d95773210a81a3bbabb20eafe9510ee3b98ea1d0fa9fa251bb921d14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eebd8616f888622f1400084458b3aea38c25e3bed11288d2a4a09a5bee65a131"
  end

  depends_on "go" => [:build, :test]
  depends_on "git"

  def install
    inreplace "internal/linker/linker.go", "\"git\"", "\"#{Formula["git"].opt_bin}/git\""
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    EOS
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
