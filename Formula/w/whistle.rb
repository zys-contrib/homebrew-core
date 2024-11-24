class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.88.tgz"
  sha256 "af32302804627afc763e7904b1ab1218105c890557744a4199d3f08328e2df2c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8b4c49132d29401830b4b9fc46160d7acc2a53e762fc2b8f9764939108c61ea8"
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
