class CssCrush < Formula
  desc "Extensible PHP based CSS preprocessor"
  homepage "https://the-echoplex.net/csscrush"
  url "https://github.com/peteboere/css-crush/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "4c4a898ada8685cf7e33a1cdaca470ca45ec66ffbc441e749b2014f3010fd0aa"
  license "MIT"
  head "https://github.com/peteboere/css-crush.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "7dd6610bca95f68d00bd025c5d30bc83f6a36a1a7a88fc6a1e30a3162e37005c"
  end

  depends_on "php"

  def install
    libexec.install Dir["*"]
    (bin+"csscrush").write <<~SHELL
      #!/bin/sh
      php "#{libexec}/cli.php" "$@"
    SHELL
  end

  test do
    (testpath/"test.crush").write <<~EOS
      @define foo #123456;
      p { color: $(foo); }
    EOS

    assert_equal "p{color:#123456}", shell_output("#{bin}/csscrush #{testpath}/test.crush").strip
  end
end
