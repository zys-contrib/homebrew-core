class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.91.tgz"
  sha256 "8a233c30e396491e1cd5402f16a1f8e3210a9c796aeccf3e592424b765a548d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1f3d714dd06800b1456bb065829120b13ebdc7789a750707bf030eaf75c3ef4d"
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
