class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.259.tgz"
  sha256 "7b91fdda0a73940c4d56768127c45641cb1d1609fad94a78e7e661a997c69274"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfaa5ae769fa9ece706f8afa76197c6cde6fe04c08a2fafda31890b9cfaa0a36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfaa5ae769fa9ece706f8afa76197c6cde6fe04c08a2fafda31890b9cfaa0a36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfaa5ae769fa9ece706f8afa76197c6cde6fe04c08a2fafda31890b9cfaa0a36"
    sha256 cellar: :any_skip_relocation, sonoma:        "0eaf88e597c311c80cf7449c746b583819ab92ed350016fe2784dee00151dc1f"
    sha256 cellar: :any_skip_relocation, ventura:       "0eaf88e597c311c80cf7449c746b583819ab92ed350016fe2784dee00151dc1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfaa5ae769fa9ece706f8afa76197c6cde6fe04c08a2fafda31890b9cfaa0a36"
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
