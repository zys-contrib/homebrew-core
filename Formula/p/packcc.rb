class Packcc < Formula
  desc "Parser generator for C"
  homepage "https://github.com/arithy/packcc"
  url "https://github.com/arithy/packcc/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "9f4d486ff34ff191cb01bd6ac41e707e93a90a581f997d45414422958af142f6"
  license "MIT"
  head "https://github.com/arithy/packcc.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "b0dbd219fd42a13a2dbc4072b536071dc3633beeb55414b3f16afdfa80f7aa52"
    sha256 arm64_sonoma:  "827595b1fc6a6fa5180b83282c3974f3e5b2d1f2df83b319955d04fd52412d9e"
    sha256 arm64_ventura: "c47145820244c77efb668c0d6ca9913aca223a43b692b5327ed18ee403af36c9"
    sha256 sonoma:        "b754eb75d7801527416e9544b803fe88d5276735302d64cff78ee906b53b47ff"
    sha256 ventura:       "11e3621b73149706b83c45b9d76815c2d02f6d831b114409a439124b8a49e06e"
    sha256 x86_64_linux:  "6b76346daa2c23bc1234ee3d23c33702606bd41f613eed0ceb4322f4733c79bc"
  end

  def install
    inreplace "src/packcc.c", "/usr/share/packcc/", "#{pkgshare}/"
    build_dir = buildpath/"build"/ENV.compiler.to_s.sub(/-\d+$/, "")
    system "make", "-C", build_dir
    bin.install build_dir/"release/bin/packcc"
    pkgshare.install "examples", "import"
  end

  test do
    cp pkgshare/"examples/ast-calc.peg", testpath
    system bin/"packcc", "ast-calc.peg"
    system ENV.cc, "ast-calc.c", "-o", "ast-calc"
    output = pipe_output(testpath/"ast-calc", "1+2*3\n")
    assert_equal <<~EOS, output
      binary: "+"
        nullary: "1"
        binary: "*"
          nullary: "2"
          nullary: "3"
    EOS
  end
end
