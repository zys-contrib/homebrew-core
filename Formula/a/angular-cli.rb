class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.0.4.tgz"
  sha256 "ba17cadf1e824b75309a31059aee89622c0fe9ef2dff612b7b522a2ebbc5fe07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4686f566838ba4cd119e82d3784a0354c120e97c975080f2c58b1a0fa5871b99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4686f566838ba4cd119e82d3784a0354c120e97c975080f2c58b1a0fa5871b99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4686f566838ba4cd119e82d3784a0354c120e97c975080f2c58b1a0fa5871b99"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c95163a96987396f3b083363184e632d414503f99c2306ddf29a35c0d7601fb"
    sha256 cellar: :any_skip_relocation, ventura:       "8c95163a96987396f3b083363184e632d414503f99c2306ddf29a35c0d7601fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4686f566838ba4cd119e82d3784a0354c120e97c975080f2c58b1a0fa5871b99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4686f566838ba4cd119e82d3784a0354c120e97c975080f2c58b1a0fa5871b99"
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
