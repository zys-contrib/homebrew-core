class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.1.0.tgz"
  sha256 "8bf5f8bcff46bb19658ecd1b78418a1a135cbb17ab6f31e3e701ab225a55af5c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62729461ac8b32ad3fcb950091e37d1c6d12a1b04a7a3464095d1515d7cd2b28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62729461ac8b32ad3fcb950091e37d1c6d12a1b04a7a3464095d1515d7cd2b28"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62729461ac8b32ad3fcb950091e37d1c6d12a1b04a7a3464095d1515d7cd2b28"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a3d19d70971a6b038d9391aae8831296b6d943e3fdcffe522e9480368a7c1bd"
    sha256 cellar: :any_skip_relocation, ventura:       "1a3d19d70971a6b038d9391aae8831296b6d943e3fdcffe522e9480368a7c1bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62729461ac8b32ad3fcb950091e37d1c6d12a1b04a7a3464095d1515d7cd2b28"
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
