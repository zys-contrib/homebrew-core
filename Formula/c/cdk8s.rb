class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.304.tgz"
  sha256 "17a817624e35287f65f50fd0f9377c07451ebb7bfb0d79412bc6dffe69405aa4"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3de2560c8047914f2482efd8b69c519b8d70d9b58e66d853635889c86d47a4f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3de2560c8047914f2482efd8b69c519b8d70d9b58e66d853635889c86d47a4f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3de2560c8047914f2482efd8b69c519b8d70d9b58e66d853635889c86d47a4f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "dca725b2b2f6f5b83e2f7af4a20adb828ce29071a05352fc35c91a64868b47eb"
    sha256 cellar: :any_skip_relocation, ventura:       "dca725b2b2f6f5b83e2f7af4a20adb828ce29071a05352fc35c91a64868b47eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3de2560c8047914f2482efd8b69c519b8d70d9b58e66d853635889c86d47a4f4"
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
