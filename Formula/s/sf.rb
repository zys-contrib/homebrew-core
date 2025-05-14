class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.88.6.tgz"
  sha256 "60f10dc8fd8823e2f87cde0384b82ede058e4a3285a6fe33ac4fa2467fbe01a6"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "600ce3a90c3cb3659ea143f40a620c9af2002119d561c69a3aaa6a1a6b8e6bdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "600ce3a90c3cb3659ea143f40a620c9af2002119d561c69a3aaa6a1a6b8e6bdd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "600ce3a90c3cb3659ea143f40a620c9af2002119d561c69a3aaa6a1a6b8e6bdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "9878807ff10dc81252ccca8f8404202bcb3d0a9e3630546c9d235a4b459fb679"
    sha256 cellar: :any_skip_relocation, ventura:       "9878807ff10dc81252ccca8f8404202bcb3d0a9e3630546c9d235a4b459fb679"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "600ce3a90c3cb3659ea143f40a620c9af2002119d561c69a3aaa6a1a6b8e6bdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "600ce3a90c3cb3659ea143f40a620c9af2002119d561c69a3aaa6a1a6b8e6bdd"
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
