class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.1.4.tgz"
  sha256 "c50ab2bb74adc9fad449f2a678a8f49ad374575b4db99d3d9f9c2d135e307e93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53aab98abe6e12332560a8daffd6e408af3b51432e2bef49ec0d7aab3bfd380a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53aab98abe6e12332560a8daffd6e408af3b51432e2bef49ec0d7aab3bfd380a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53aab98abe6e12332560a8daffd6e408af3b51432e2bef49ec0d7aab3bfd380a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e35fd78a55767ac1baa0624dba8580739fd530fe184ecbe984afc14678b93179"
    sha256 cellar: :any_skip_relocation, ventura:       "e35fd78a55767ac1baa0624dba8580739fd530fe184ecbe984afc14678b93179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53aab98abe6e12332560a8daffd6e408af3b51432e2bef49ec0d7aab3bfd380a"
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
