class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.2.12.tgz"
  sha256 "df3c30ebb22c9d2cab1d496bc72ed4fd4fa24ddd0cf1c4e7e96d8f02c83035be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc26ab6100c45cd7056803fd18dbe914e69e7f1140362330c7551aeceaaad658"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc26ab6100c45cd7056803fd18dbe914e69e7f1140362330c7551aeceaaad658"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc26ab6100c45cd7056803fd18dbe914e69e7f1140362330c7551aeceaaad658"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f6e42d2a5fb514d1b9bc3b8ad7ffe72ed0ffb1777707901b153a0bd301b7847"
    sha256 cellar: :any_skip_relocation, ventura:       "6f6e42d2a5fb514d1b9bc3b8ad7ffe72ed0ffb1777707901b153a0bd301b7847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc26ab6100c45cd7056803fd18dbe914e69e7f1140362330c7551aeceaaad658"
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
