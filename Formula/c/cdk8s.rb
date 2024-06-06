require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.138.tgz"
  sha256 "05ef53cab3b9df0e7cf971e9e69cc43a1022e20c20607557477c150a89293aa0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9cad35f1528d89e4439e68d997297f913d409b19d3e92edf3b2a53100ad938f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9cad35f1528d89e4439e68d997297f913d409b19d3e92edf3b2a53100ad938f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9cad35f1528d89e4439e68d997297f913d409b19d3e92edf3b2a53100ad938f"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fee43f74192a10c9d268cc79461a8b28f74fcebc13cf70e54de87b0bad1d7ed"
    sha256 cellar: :any_skip_relocation, ventura:        "8fee43f74192a10c9d268cc79461a8b28f74fcebc13cf70e54de87b0bad1d7ed"
    sha256 cellar: :any_skip_relocation, monterey:       "8fee43f74192a10c9d268cc79461a8b28f74fcebc13cf70e54de87b0bad1d7ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab94edbada247b8fc70d5e0cce855df4fe257fea7bdab16687f985459154dcae"
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
