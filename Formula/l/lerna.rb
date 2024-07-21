require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-8.1.7.tgz"
  sha256 "63608afc2f29b798f35b7b8acfd8ae21846d16cfe5467baae1479414e0a91080"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6bfbccbd6815b7ae094e67dac5e6b6332362db134a03f3ea1ae421e3a1c24df3"
    sha256 cellar: :any,                 arm64_ventura:  "6bfbccbd6815b7ae094e67dac5e6b6332362db134a03f3ea1ae421e3a1c24df3"
    sha256 cellar: :any,                 arm64_monterey: "6bfbccbd6815b7ae094e67dac5e6b6332362db134a03f3ea1ae421e3a1c24df3"
    sha256 cellar: :any,                 sonoma:         "f19b2101223d179dd0ae37df27a4432296e3a885a48cd5f9df47752a9675b272"
    sha256 cellar: :any,                 ventura:        "f19b2101223d179dd0ae37df27a4432296e3a885a48cd5f9df47752a9675b272"
    sha256 cellar: :any,                 monterey:       "f19b2101223d179dd0ae37df27a4432296e3a885a48cd5f9df47752a9675b272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffa1085cd2aeca3a92539e5f3b7d7348a7bf7378a586d85c5884a73f1d2b2060"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
