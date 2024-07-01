require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.161.tgz"
  sha256 "3090833c8d31ffd96df794c2d910ced073a795fcf59fd28736fc91a31aa217be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a94ae59c0b543a7f6d1ec965449938f207169a77720925107cc936ae48c8e2a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a94ae59c0b543a7f6d1ec965449938f207169a77720925107cc936ae48c8e2a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a94ae59c0b543a7f6d1ec965449938f207169a77720925107cc936ae48c8e2a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "69c86cdbe964aff2e6a8f456371081db0da05f1095499e585cfb0afb1e5f30e9"
    sha256 cellar: :any_skip_relocation, ventura:        "69c86cdbe964aff2e6a8f456371081db0da05f1095499e585cfb0afb1e5f30e9"
    sha256 cellar: :any_skip_relocation, monterey:       "69c86cdbe964aff2e6a8f456371081db0da05f1095499e585cfb0afb1e5f30e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12405c621bcfefd7973ba301001610675e50a3942ce59ec46643e1ea7507159d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
