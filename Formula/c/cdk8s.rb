require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.174.tgz"
  sha256 "fa4bb59bfdcba5723e8e317b4a36f78ea48ee29a4f0990f7ac4bf15b64149c89"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e26a9a9a2abe6a7520e619b3f4276c8815876e47e8f0b6a804e05a81c3e20475"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e26a9a9a2abe6a7520e619b3f4276c8815876e47e8f0b6a804e05a81c3e20475"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e26a9a9a2abe6a7520e619b3f4276c8815876e47e8f0b6a804e05a81c3e20475"
    sha256 cellar: :any_skip_relocation, sonoma:         "5aff1e9fb4b06acbc394d1e4628647808ff87670e72bd1e398c0de7039a5d9cd"
    sha256 cellar: :any_skip_relocation, ventura:        "5aff1e9fb4b06acbc394d1e4628647808ff87670e72bd1e398c0de7039a5d9cd"
    sha256 cellar: :any_skip_relocation, monterey:       "5aff1e9fb4b06acbc394d1e4628647808ff87670e72bd1e398c0de7039a5d9cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cea0d2e1795918a3c89a5ea48f7bfcfa8e670dc920287b06b13012bdc59afab6"
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
