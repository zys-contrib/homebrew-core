class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.1.6.tgz"
  sha256 "9a03ca08291a3aac0b76198db04b3d782604e91d9e323c3c78e855550503a3a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "597f0cc1f62081e687be7c24083019044869bc7c5fa0a98ab2cd7b7e4dfff86f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "597f0cc1f62081e687be7c24083019044869bc7c5fa0a98ab2cd7b7e4dfff86f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "597f0cc1f62081e687be7c24083019044869bc7c5fa0a98ab2cd7b7e4dfff86f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce59ac7bcdc6804907babd225716146dab9faabcb0291d6e57921a876ea11e90"
    sha256 cellar: :any_skip_relocation, ventura:       "ce59ac7bcdc6804907babd225716146dab9faabcb0291d6e57921a876ea11e90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "597f0cc1f62081e687be7c24083019044869bc7c5fa0a98ab2cd7b7e4dfff86f"
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
