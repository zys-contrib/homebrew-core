class Xgo < Formula
  desc "AI-native programming language that integrates software engineering"
  homepage "https://xgo.dev/"
  url "https://github.com/goplus/xgo/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "e7d80a6760f794ffb4f30c89097b8903f8a1e8c6b60706673d88bcdc304f05c8"
  license "Apache-2.0"
  head "https://github.com/goplus/xgo.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "101cc1fa5d0656705b04c9f5e88e1af6da48a4dbd7d384dc880d701c543d4b21"
    sha256 arm64_sonoma:  "bd76f9478420297ec169a0d75826acb1bf5a8cecf2bf979e53f017b268e91ee6"
    sha256 arm64_ventura: "d349e58a80d2b68909b1df56249fe60a2c9671799ff86a0f77472dd068489aa0"
    sha256 sonoma:        "7ad337b755d679c94888256bb9806d0cd9f6812b5e0d5d2f07fc445fa8892330"
    sha256 ventura:       "137aa990c331adc079964f26d1a5e9df8436f02d53b642c79acc632f97d11338"
    sha256 x86_64_linux:  "024122c68e709ccfe12576d96f148d77cba6c58f5bb91232a3161a8ac94d5900"
  end

  depends_on "go"

  def install
    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmd/make.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    bin.install_symlink Dir[libexec/"bin/*"]

    generate_completions_from_executable(bin/"xgo", "completion")
  end

  test do
    system bin/"xgo", "mod", "init", "hello"
    (testpath/"hello.xgo").write <<~XGO
      println("Hello World")
    XGO

    # Run xgo fmt, run, build
    assert_equal "v#{version}", shell_output("#{bin}/xgo env XGOVERSION").chomp
    system bin/"xgo", "fmt", "hello.xgo"
    assert_equal "Hello World\n", shell_output("#{bin}/xgo run hello.xgo 2>&1")
    system bin/"xgo", "build", "-o", "hello"
    assert_equal "Hello World\n", shell_output("./hello 2>&1")
  end
end
