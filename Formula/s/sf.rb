class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.63.7.tgz"
  sha256 "0258e405bc1f2f70cc23a668161bcefba519d5d726613cfc5d8cfa465af7a660"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29e734989af6e105787b56f49dac7b3f3635558042dd8dd7ba007c6d60be532d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29e734989af6e105787b56f49dac7b3f3635558042dd8dd7ba007c6d60be532d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29e734989af6e105787b56f49dac7b3f3635558042dd8dd7ba007c6d60be532d"
    sha256 cellar: :any_skip_relocation, sonoma:        "220eafeeebd0c1a99fdd1901532cb8f0b5f20f8da37d529ec15d875651e26d0e"
    sha256 cellar: :any_skip_relocation, ventura:       "220eafeeebd0c1a99fdd1901532cb8f0b5f20f8da37d529ec15d875651e26d0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29e734989af6e105787b56f49dac7b3f3635558042dd8dd7ba007c6d60be532d"
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
