class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.87.tgz"
  sha256 "18eb866c693eeb6ed7c1a09df31d96d60b0efad22ed80b9052285a5fbcdd658f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eb763c9d828fc857a6650904e57287609479c3c66934bee4b291bba3f778e86a"
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
