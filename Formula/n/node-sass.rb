class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.79.2.tgz"
  sha256 "262b91c5d46bbff19c21b1984f95f4c940b1eb4b8eb95b4fead457e55c12279e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1dee611149e4d111a6190361a0fe279c53a4a9ee8001344e932ce0816d3cd3cc"
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
