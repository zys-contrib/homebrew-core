class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.0.2.tgz"
  sha256 "b174fc767d1e3507108df8c190b90783f5fa91375966192565db704f40dec3ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0f38c014199f4af0f2f5095831534b447a7df4f83b4027b4bbe50b9989a992f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0f38c014199f4af0f2f5095831534b447a7df4f83b4027b4bbe50b9989a992f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0f38c014199f4af0f2f5095831534b447a7df4f83b4027b4bbe50b9989a992f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab382544be13efafef6510d3d3a817759b1ef0117ce451f04d82c9751de10414"
    sha256 cellar: :any_skip_relocation, ventura:       "ab382544be13efafef6510d3d3a817759b1ef0117ce451f04d82c9751de10414"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0f38c014199f4af0f2f5095831534b447a7df4f83b4027b4bbe50b9989a992f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0f38c014199f4af0f2f5095831534b447a7df4f83b4027b4bbe50b9989a992f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end
