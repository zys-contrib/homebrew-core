class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.84.tgz"
  sha256 "f41dc5eff26fc75b256357d9a8e78543f6ab3166f5c07720ae058da907a4d111"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bb76df09fff61e797e4d66e52633024eae50941cab0a88c99d77cc01c8adc11f"
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
