class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.92.tgz"
  sha256 "648cfd15c94bb54d9699adc5a8a8c0cd9934fb951d8e4f88b5b36056a068b153"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "88cd2b60cb3ce270c812c56b5943e53228d9287a627e182f3398ab08af09433b"
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
