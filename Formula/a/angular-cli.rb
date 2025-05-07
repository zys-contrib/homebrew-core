class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.2.11.tgz"
  sha256 "a4ea045fcecc07f2eb963627019982c964280994e39c43393f72713892ae48a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dd3916a0e9ecfc0f2c9eaa6bc46437594f23b6a090bd0562286ce632c6ba82e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dd3916a0e9ecfc0f2c9eaa6bc46437594f23b6a090bd0562286ce632c6ba82e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7dd3916a0e9ecfc0f2c9eaa6bc46437594f23b6a090bd0562286ce632c6ba82e"
    sha256 cellar: :any_skip_relocation, sonoma:        "20ef2c30fa3a5c534c1368e89e20f3eba21044a2f2923d759bc2a48952d79aa4"
    sha256 cellar: :any_skip_relocation, ventura:       "20ef2c30fa3a5c534c1368e89e20f3eba21044a2f2923d759bc2a48952d79aa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dd3916a0e9ecfc0f2c9eaa6bc46437594f23b6a090bd0562286ce632c6ba82e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dd3916a0e9ecfc0f2c9eaa6bc46437594f23b6a090bd0562286ce632c6ba82e"
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
