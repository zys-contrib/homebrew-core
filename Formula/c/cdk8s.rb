class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.75.tgz"
  sha256 "dbbefdaaf0f0412ed1b99ca84e62e89ba71c8bc5419758c4b3961665fd841131"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cc15998f68eea3f8ac0f43b9af83d930dad78e3c5894f04a6999b6125cb2474"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cc15998f68eea3f8ac0f43b9af83d930dad78e3c5894f04a6999b6125cb2474"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9cc15998f68eea3f8ac0f43b9af83d930dad78e3c5894f04a6999b6125cb2474"
    sha256 cellar: :any_skip_relocation, sonoma:        "f48cb862f694b4b4d73d92005ebc7f718752be7c2e2cacb6dc8e9500b5f54db0"
    sha256 cellar: :any_skip_relocation, ventura:       "f48cb862f694b4b4d73d92005ebc7f718752be7c2e2cacb6dc8e9500b5f54db0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cc15998f68eea3f8ac0f43b9af83d930dad78e3c5894f04a6999b6125cb2474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cc15998f68eea3f8ac0f43b9af83d930dad78e3c5894f04a6999b6125cb2474"
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
