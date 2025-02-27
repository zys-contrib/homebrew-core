class JsBeautify < Formula
  desc "JavaScript, CSS and HTML unobfuscator and beautifier"
  homepage "https://beautifier.io"
  url "https://registry.npmjs.org/js-beautify/-/js-beautify-1.15.4.tgz"
  sha256 "5feefb437c9467e789d179fc4cbc4f942008c05222f6b573a4f03ee41e31d9a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2332076adad7076309a54f947f9893ede77035ec5afa6bd951102229284cfeec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2332076adad7076309a54f947f9893ede77035ec5afa6bd951102229284cfeec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2332076adad7076309a54f947f9893ede77035ec5afa6bd951102229284cfeec"
    sha256 cellar: :any_skip_relocation, sonoma:        "5772744b71950a488cbf593992b6bad07733966df35a2833245b8695ffb4181a"
    sha256 cellar: :any_skip_relocation, ventura:       "5772744b71950a488cbf593992b6bad07733966df35a2833245b8695ffb4181a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2332076adad7076309a54f947f9893ede77035ec5afa6bd951102229284cfeec"
  end

  depends_on "node"

  conflicts_with "jsbeautifier", because: "both install `js-beautify` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    javascript = "if ('this_is'==/an_example/){of_beautifier();}else{var a=b?(c%d):e[f];}"
    assert_equal <<~EOS.chomp, pipe_output(bin/"js-beautify", javascript)
      if ('this_is' == /an_example/) {
          of_beautifier();
      } else {
          var a = b ? (c % d) : e[f];
      }
    EOS
  end
end
