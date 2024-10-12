class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.244.tgz"
  sha256 "5e1c8c73656753b9b6e2705e289311742a1994060e3b7fdd048977eb76940048"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "087c07f46af0a1caaba92c7ec16a0a80413cbfafb80d2f2e0d8cc7a954cf7278"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "087c07f46af0a1caaba92c7ec16a0a80413cbfafb80d2f2e0d8cc7a954cf7278"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "087c07f46af0a1caaba92c7ec16a0a80413cbfafb80d2f2e0d8cc7a954cf7278"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c4636e9f8677ba094f85b0e93840e57dd49b9ea391c6c0149a2f17211f2e338"
    sha256 cellar: :any_skip_relocation, ventura:       "9c4636e9f8677ba094f85b0e93840e57dd49b9ea391c6c0149a2f17211f2e338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "087c07f46af0a1caaba92c7ec16a0a80413cbfafb80d2f2e0d8cc7a954cf7278"
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
