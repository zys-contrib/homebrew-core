class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.251.tgz"
  sha256 "cc669e31fe3ffd428fd97bc15c099c6740a4681347bcdb1e666a25ac65ff8033"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b3a8d8d883540706d0acb6ae05691c957d3bcdc12b35789d30260b74b8b7c46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b3a8d8d883540706d0acb6ae05691c957d3bcdc12b35789d30260b74b8b7c46"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b3a8d8d883540706d0acb6ae05691c957d3bcdc12b35789d30260b74b8b7c46"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f1457c7c1fa7fe736634536a202da52c6571afdbd164f6a65b4a74c432ebfdd"
    sha256 cellar: :any_skip_relocation, ventura:       "1f1457c7c1fa7fe736634536a202da52c6571afdbd164f6a65b4a74c432ebfdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b3a8d8d883540706d0acb6ae05691c957d3bcdc12b35789d30260b74b8b7c46"
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
