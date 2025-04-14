class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.96.tgz"
  sha256 "1cd157fa85a9a910b7d617561b1d5497388cb3c33204b1f650d7d00a6092ef9f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c7b044a9fd793178406dade1946884f29c05c82ed5ed3e16a7920491db6f75df"
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
