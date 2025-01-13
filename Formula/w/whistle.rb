class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.93.tgz"
  sha256 "b5f1afa5b2da8f50b90633cdddd7421a3bc652b7131e50f14234d648153f3917"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2fe6eaccddb15ec48e48fe22b9ff1069db50ff075956ee0b6757e2c0a4540c4f"
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
