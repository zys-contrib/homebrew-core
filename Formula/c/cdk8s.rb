class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.260.tgz"
  sha256 "9635a3fe1eeed419a3c52f4c19690aae10a2c461e130e4c55faa8669b0c28c43"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2c31100fc02a4611396da2867dbfe76018138fab9bf2c34b33663826448b133"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2c31100fc02a4611396da2867dbfe76018138fab9bf2c34b33663826448b133"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2c31100fc02a4611396da2867dbfe76018138fab9bf2c34b33663826448b133"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea1d0cd215880924fbda567a49abdcdf7829e0a45a57ea09cec4763b377bb638"
    sha256 cellar: :any_skip_relocation, ventura:       "ea1d0cd215880924fbda567a49abdcdf7829e0a45a57ea09cec4763b377bb638"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2c31100fc02a4611396da2867dbfe76018138fab9bf2c34b33663826448b133"
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
