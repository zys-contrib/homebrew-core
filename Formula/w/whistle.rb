class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.98.tgz"
  sha256 "eae840bd72e5a40c46f32669c1e67b30a959e614e015723a9343458ced6ce4fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "95d869fa858f664fd1e1af403bda1fcb2bba3dcd7724b85773803eb2c1813a3f"
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
