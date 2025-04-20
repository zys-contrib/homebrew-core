class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.97.tgz"
  sha256 "167eee9b1130e7a9fc701d93c5da0626551f96177fedcd6b96ffcbc2e18b0a9a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9935d777cc391e0c02c59cfeda3c7c7bb0562bf642fbcc4b0d3e10f08ff0e780"
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
