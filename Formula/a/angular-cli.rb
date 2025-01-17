class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.1.2.tgz"
  sha256 "af59c0ce50025c963b55a5ea131eac862eee05f6817aef1ec026e1448fdfd6b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "345d056d6184d9216e086814aca8ffb44f3d7d4e52a4987d6392f7bca2f6279c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "345d056d6184d9216e086814aca8ffb44f3d7d4e52a4987d6392f7bca2f6279c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "345d056d6184d9216e086814aca8ffb44f3d7d4e52a4987d6392f7bca2f6279c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e09d1db81b64b9293b314d52c48fb0604d6e1f64c0f0b540c3124123f829f41"
    sha256 cellar: :any_skip_relocation, ventura:       "8e09d1db81b64b9293b314d52c48fb0604d6e1f64c0f0b540c3124123f829f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "345d056d6184d9216e086814aca8ffb44f3d7d4e52a4987d6392f7bca2f6279c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
