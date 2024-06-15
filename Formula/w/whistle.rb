require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.74.tgz"
  sha256 "1e8bfe4ab3417f8769e90de3988dd877404cf936f3a830d014939b4179e58878"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5c5e92706c22b1987ae1178c844e56adf08f7d0f481dd4ba430faf33455b505"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5c5e92706c22b1987ae1178c844e56adf08f7d0f481dd4ba430faf33455b505"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5c5e92706c22b1987ae1178c844e56adf08f7d0f481dd4ba430faf33455b505"
    sha256 cellar: :any_skip_relocation, sonoma:         "f723d3afc075592a53c84be59853e3bc1a29eee0866a9a2445a419e0377f28b5"
    sha256 cellar: :any_skip_relocation, ventura:        "f723d3afc075592a53c84be59853e3bc1a29eee0866a9a2445a419e0377f28b5"
    sha256 cellar: :any_skip_relocation, monterey:       "f723d3afc075592a53c84be59853e3bc1a29eee0866a9a2445a419e0377f28b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5540729f6e8ba1800ce59cbcc2a39dec4f813f9e180d1e8f3d7217574f347901"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove x86 specific optional feature
    node_modules = libexec/"lib/node_modules/whistle/node_modules"
    rm_f node_modules/"set-global-proxy/lib/mac/whistle" if Hardware::CPU.arm?
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
