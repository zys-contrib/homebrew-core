class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.1.8.tgz"
  sha256 "00c3f2202139216a3694772835a53e253966ea5e6174c8a9dbe6210e405f1153"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "996887f0770415f7f5c48b185315cd6029e61acd214e3d6d1f23fcdd546c45b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "996887f0770415f7f5c48b185315cd6029e61acd214e3d6d1f23fcdd546c45b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "996887f0770415f7f5c48b185315cd6029e61acd214e3d6d1f23fcdd546c45b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ae800ef9d326b4b0f75dbef8074bac77858d02c85cd5703984a8f52f4ecfff3"
    sha256 cellar: :any_skip_relocation, ventura:       "5ae800ef9d326b4b0f75dbef8074bac77858d02c85cd5703984a8f52f4ecfff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "996887f0770415f7f5c48b185315cd6029e61acd214e3d6d1f23fcdd546c45b8"
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
