class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.1.7.tgz"
  sha256 "5bcf0f78e33ef746003110707ee7084479f5cfc95bf17a19897f70314b50b184"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b6b671f72dbf9424ba32c879ca331114aa801518bb514b5a41b34a55978b508"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b6b671f72dbf9424ba32c879ca331114aa801518bb514b5a41b34a55978b508"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b6b671f72dbf9424ba32c879ca331114aa801518bb514b5a41b34a55978b508"
    sha256 cellar: :any_skip_relocation, sonoma:        "78c641242ff8ae8ce9404e751d063f1f99f6dc451c60f1d52f28c4a757a2f3aa"
    sha256 cellar: :any_skip_relocation, ventura:       "78c641242ff8ae8ce9404e751d063f1f99f6dc451c60f1d52f28c4a757a2f3aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b6b671f72dbf9424ba32c879ca331114aa801518bb514b5a41b34a55978b508"
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
