class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.78.tgz"
  sha256 "fbfeb5f311517b9fc35c64b85dcd446795dd61c60f4dbb051e3675800a02fca8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52e4e6575e280e9bc9c197c7a93ccd51eedc89ef5139c2fde3d52cbd11578cb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52e4e6575e280e9bc9c197c7a93ccd51eedc89ef5139c2fde3d52cbd11578cb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52e4e6575e280e9bc9c197c7a93ccd51eedc89ef5139c2fde3d52cbd11578cb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf0d619e577e5b49df0378b4efbba78bfd76ddb9e2300bdc905c4f9fce7ff09b"
    sha256 cellar: :any_skip_relocation, ventura:       "bf0d619e577e5b49df0378b4efbba78bfd76ddb9e2300bdc905c4f9fce7ff09b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52e4e6575e280e9bc9c197c7a93ccd51eedc89ef5139c2fde3d52cbd11578cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52e4e6575e280e9bc9c197c7a93ccd51eedc89ef5139c2fde3d52cbd11578cb3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
