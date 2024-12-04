class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.68.6.tgz"
  sha256 "ef05660ef80c040accb0f4fd5c09624d3d28d3affbdae71262951da6ab1444a4"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3bdba096c1c2688ee2d350e56d3162c98e8c123bcc5f177d711dfae141de4cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3bdba096c1c2688ee2d350e56d3162c98e8c123bcc5f177d711dfae141de4cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3bdba096c1c2688ee2d350e56d3162c98e8c123bcc5f177d711dfae141de4cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ed7448563b2511acd55494bfbf3915b6fd184a2a96c31da2c3dfb4995640952"
    sha256 cellar: :any_skip_relocation, ventura:       "5ed7448563b2511acd55494bfbf3915b6fd184a2a96c31da2c3dfb4995640952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3bdba096c1c2688ee2d350e56d3162c98e8c123bcc5f177d711dfae141de4cb"
  end

  depends_on "node@20"

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
