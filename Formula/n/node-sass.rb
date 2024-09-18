class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.79.1.tgz"
  sha256 "1533d1c2d9425ead4d4bfb1f24cb62b1c063232e8bc7fbbccc3ddb1d8454f229"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "842c73b1f6a1f35613dc5242b476e3076daf5ea36d6c248b412c8989c78c148e"
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
