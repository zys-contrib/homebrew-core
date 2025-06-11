class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.92.7.tgz"
  sha256 "29e4eb1ebd7d6c25f7cce6a902a03de094788afcf5600c3d58f5cf0d233ae633"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7eb609ae9becd45f4011f36ebf5453e7c1b08037a225f3a89649da878a3d305"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7eb609ae9becd45f4011f36ebf5453e7c1b08037a225f3a89649da878a3d305"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7eb609ae9becd45f4011f36ebf5453e7c1b08037a225f3a89649da878a3d305"
    sha256 cellar: :any_skip_relocation, sonoma:        "d399f7da013517926e71e747337f7be6ff1aab7b223016ec4d74db166fbfa7a9"
    sha256 cellar: :any_skip_relocation, ventura:       "d399f7da013517926e71e747337f7be6ff1aab7b223016ec4d74db166fbfa7a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7eb609ae9becd45f4011f36ebf5453e7c1b08037a225f3a89649da878a3d305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7eb609ae9becd45f4011f36ebf5453e7c1b08037a225f3a89649da878a3d305"
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
