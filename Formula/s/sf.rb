class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.72.21.tgz"
  sha256 "3eb159ff592ee46843832ff00e6962db1a543bc24147112a2e0f75e2b419cd75"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7fe6acc4de243ff1d5c044e7003207a8a3a86b6df346dc63a1039ae1359288f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7fe6acc4de243ff1d5c044e7003207a8a3a86b6df346dc63a1039ae1359288f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7fe6acc4de243ff1d5c044e7003207a8a3a86b6df346dc63a1039ae1359288f"
    sha256 cellar: :any_skip_relocation, sonoma:        "586d76e5aa1023201f929fe4fd9eac89e0264902b926d8d2ea0366e97118eda5"
    sha256 cellar: :any_skip_relocation, ventura:       "586d76e5aa1023201f929fe4fd9eac89e0264902b926d8d2ea0366e97118eda5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7fe6acc4de243ff1d5c044e7003207a8a3a86b6df346dc63a1039ae1359288f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"sf", "project", "generate", "-n", "projectname", "-t", "empty"
    assert_predicate testpath/"projectname", :exist?
    assert_predicate testpath/"projectname/config/project-scratch-def.json", :exist?
    assert_predicate testpath/"projectname/README.md", :exist?
    assert_predicate testpath/"projectname/sfdx-project.json", :exist?
    assert_predicate testpath/"projectname/.forceignore", :exist?
  end
end
