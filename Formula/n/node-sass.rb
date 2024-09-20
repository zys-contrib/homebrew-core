class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.79.2.tgz"
  sha256 "262b91c5d46bbff19c21b1984f95f4c940b1eb4b8eb95b4fead457e55c12279e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1417d12cb6340b3938743e436cf8e30b30bd8c26aad7f8291fa307a99edcff1d"
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
