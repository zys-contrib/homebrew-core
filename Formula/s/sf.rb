class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.85.7.tgz"
  sha256 "dcfa4922b22f6a8692a6c08fd8cb023ca344e86d1718a600962b86675524a46f"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "763885acc4c6e34b117bcadf864ee20d4502a8fa990096c9c2648df51c1e06a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "763885acc4c6e34b117bcadf864ee20d4502a8fa990096c9c2648df51c1e06a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "763885acc4c6e34b117bcadf864ee20d4502a8fa990096c9c2648df51c1e06a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "70d2e33693858ba9a47276142cf84ac091766bee72e6a18c7c417b07caa1cd7d"
    sha256 cellar: :any_skip_relocation, ventura:       "70d2e33693858ba9a47276142cf84ac091766bee72e6a18c7c417b07caa1cd7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "763885acc4c6e34b117bcadf864ee20d4502a8fa990096c9c2648df51c1e06a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "763885acc4c6e34b117bcadf864ee20d4502a8fa990096c9c2648df51c1e06a3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"sf", "project", "generate", "-n", "projectname", "-t", "empty"
    assert_path_exists testpath/"projectname"
    assert_path_exists testpath/"projectname/config/project-scratch-def.json"
    assert_path_exists testpath/"projectname/README.md"
    assert_path_exists testpath/"projectname/sfdx-project.json"
    assert_path_exists testpath/"projectname/.forceignore"
  end
end
