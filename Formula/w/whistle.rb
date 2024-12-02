class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.90.tgz"
  sha256 "e7069ef57d8722624801f45cff9bcea2d6a1c101010d45baafd911f3a49acefa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "87a385f90d88e2edf5a545191170f2e150b409b1a4ea07cc198c9bb5713c0475"
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
