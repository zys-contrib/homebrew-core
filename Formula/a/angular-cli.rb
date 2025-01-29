class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.1.5.tgz"
  sha256 "7f455563c1f38cb41945775f55e4bfda0f437d4df8d09ad632da31c0f14d3d36"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd4a5ea064ef1632e4c60443bbd450ef191347e4d318b1881bf2929507cb7cf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd4a5ea064ef1632e4c60443bbd450ef191347e4d318b1881bf2929507cb7cf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd4a5ea064ef1632e4c60443bbd450ef191347e4d318b1881bf2929507cb7cf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d66f78d5ada5376097e613271ec590154ce06f9a8042d1bc2c18deeb1be4c18"
    sha256 cellar: :any_skip_relocation, ventura:       "0d66f78d5ada5376097e613271ec590154ce06f9a8042d1bc2c18deeb1be4c18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd4a5ea064ef1632e4c60443bbd450ef191347e4d318b1881bf2929507cb7cf1"
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
