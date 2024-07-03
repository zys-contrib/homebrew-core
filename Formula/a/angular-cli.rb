require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.0.7.tgz"
  sha256 "863145e2357ae0f5469218a8bd6050d280c60f00eac70da5395ff106a79bd4e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9cdb6f9c364ffb98058473fe620c3b0cc6355e40601a4e5ef6a4e2aa7b663b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9cdb6f9c364ffb98058473fe620c3b0cc6355e40601a4e5ef6a4e2aa7b663b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9cdb6f9c364ffb98058473fe620c3b0cc6355e40601a4e5ef6a4e2aa7b663b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "3127ac71986b07ff5122dce30b11d93b507d607a3a2e1a40c4b11e4a6f816e6b"
    sha256 cellar: :any_skip_relocation, ventura:        "3127ac71986b07ff5122dce30b11d93b507d607a3a2e1a40c4b11e4a6f816e6b"
    sha256 cellar: :any_skip_relocation, monterey:       "3127ac71986b07ff5122dce30b11d93b507d607a3a2e1a40c4b11e4a6f816e6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf0406a04c859a206e9b2c25a43a03948bdb632e9c9ff42819745ab82b6aa985"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
