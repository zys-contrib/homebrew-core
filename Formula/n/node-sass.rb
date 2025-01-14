class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.83.4.tgz"
  sha256 "04dfdce75ec4fc0f4b86f7a04d69dd05ccaa8ec86c79d0145129b9389f253b65"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "a5525f4edc7a54be7a70d234d39ad42563f09eed547a025b6b7669301c8b0fd0"
    sha256                               arm64_sonoma:  "17ef224fa46e33065812a51c95d428dad70b6332491d485ed1f332aaf5ce36b5"
    sha256                               arm64_ventura: "d3f5af5a11dc632dee150e0668f5c9559b4d16786e397724d415ea60d35c17a6"
    sha256                               sonoma:        "8e0df65e7e6339085f781b411c06a0537dc0d8c59789258c94418690bc1276c4"
    sha256                               ventura:       "8eed7363370c09d05a028d253f17490ac8c9d81965150ba1f7048d7bb808c120"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f15cc2bf7ddd97fa00ef9df66756290f28f64d189187211413b0dcd2823c36d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
