class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.83.tgz"
  sha256 "a8784476cd25108948a7f0ef6b26fb4f64defccee96464ed7d369be56864bc94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ae1396bff8ecff8a1f60748521fe62dd8ec377e384612fae884fec2a64a022a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
