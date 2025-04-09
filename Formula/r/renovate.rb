class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.237.0.tgz"
  sha256 "8d3eea1d67ea4342ed584abd2eb34e3624a913e3de7c7c2276ee39400711285b"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "497b1164b1bec4bcf69f46eb3e3c93b16e357c53bdf02cc8548e09f6e0e6860c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "672bd16251e08f6c2f5f05ecfa59be8599c2ee23bffe00a09a19995219f6aed2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f969f44b61d083dbe0c4b670e75b0cc7ba5a150113ed2acf207f110aef839653"
    sha256 cellar: :any_skip_relocation, sonoma:        "063f6cbc2b96b19822b67f97e4de3988ab11a23362ea9e763f11be818a7da882"
    sha256 cellar: :any_skip_relocation, ventura:       "322e11dc7fdc9fc43829c5c5b51bc24e64cbdef913bd803865b0e1067578aee4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4315c03ceeeda2465a789bb787e6eab2a43c7ea43bbb93c1592c04f7a9fe7834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85165bf8179c083ae5bba3937f99303250eb72fea98a87ce57cc75914899aad6"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
