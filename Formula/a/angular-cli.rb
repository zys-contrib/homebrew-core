class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.2.3.tgz"
  sha256 "aad685c607f60eacd0857a79cf30927e73d02d3dfe03ec4f077afc4bc948b67c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0038a67cd852ec65172ad08c211977d445901c28851d409fb88f911a2bd899f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0038a67cd852ec65172ad08c211977d445901c28851d409fb88f911a2bd899f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0038a67cd852ec65172ad08c211977d445901c28851d409fb88f911a2bd899f"
    sha256 cellar: :any_skip_relocation, sonoma:         "80148bacf8f41b7a0c0063aeb2ab1e819aa320d5590e057538ebccd07431ccb4"
    sha256 cellar: :any_skip_relocation, ventura:        "80148bacf8f41b7a0c0063aeb2ab1e819aa320d5590e057538ebccd07431ccb4"
    sha256 cellar: :any_skip_relocation, monterey:       "80148bacf8f41b7a0c0063aeb2ab1e819aa320d5590e057538ebccd07431ccb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0038a67cd852ec65172ad08c211977d445901c28851d409fb88f911a2bd899f"
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
