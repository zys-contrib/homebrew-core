class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.2.8.tgz"
  sha256 "41a4ec997a6b013d2491bad11702c08558e8a99b12dc9ab3e20e4055cea12cdb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c6ffbbf7f0cc79f99dd63460639af1752436de660277fbc6a2f066d8e827b1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c6ffbbf7f0cc79f99dd63460639af1752436de660277fbc6a2f066d8e827b1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c6ffbbf7f0cc79f99dd63460639af1752436de660277fbc6a2f066d8e827b1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "be69cd1e398779dfd02eb540c7e4176e578b01ead311108ec2c3c046797aab2e"
    sha256 cellar: :any_skip_relocation, ventura:       "be69cd1e398779dfd02eb540c7e4176e578b01ead311108ec2c3c046797aab2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c6ffbbf7f0cc79f99dd63460639af1752436de660277fbc6a2f066d8e827b1e"
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
