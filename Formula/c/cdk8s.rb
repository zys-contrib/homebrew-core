require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.159.tgz"
  sha256 "cb63614d58c7fc161d6bc1da8574f206cb66a64555a63214a7e0b38eef154b32"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5d01cb708024131ccf48c7f1f1b31a75d283ad4d29dfe5748bd8639a70575af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5d01cb708024131ccf48c7f1f1b31a75d283ad4d29dfe5748bd8639a70575af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5d01cb708024131ccf48c7f1f1b31a75d283ad4d29dfe5748bd8639a70575af"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce290428862ff718e47e71d3e15ea4a1293c93c88e4c595ffb9d8f7fb7a5e028"
    sha256 cellar: :any_skip_relocation, ventura:        "ce290428862ff718e47e71d3e15ea4a1293c93c88e4c595ffb9d8f7fb7a5e028"
    sha256 cellar: :any_skip_relocation, monterey:       "ce290428862ff718e47e71d3e15ea4a1293c93c88e4c595ffb9d8f7fb7a5e028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6aa73ba5dca3af7332fbfdcc8a80b6884ffe533ff77915a7f62c6b7ce34b6684"
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
