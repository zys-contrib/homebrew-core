class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.0.5.tgz"
  sha256 "51ff7a9828d91b0d9c075bc0c62268a6c7597949696f750a90c3b672db6b53da"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5080671fa7e997d0aa177abb03ce59ddb22306a6a96c14f27d9221be29beb81f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5080671fa7e997d0aa177abb03ce59ddb22306a6a96c14f27d9221be29beb81f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5080671fa7e997d0aa177abb03ce59ddb22306a6a96c14f27d9221be29beb81f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6d21866fac9edb7bd0a54451218e682c8e5cd6fbdc24dd11cdf764188f23a6d"
    sha256 cellar: :any_skip_relocation, ventura:       "a6d21866fac9edb7bd0a54451218e682c8e5cd6fbdc24dd11cdf764188f23a6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5080671fa7e997d0aa177abb03ce59ddb22306a6a96c14f27d9221be29beb81f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5080671fa7e997d0aa177abb03ce59ddb22306a6a96c14f27d9221be29beb81f"
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
