class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.1.1.tgz"
  sha256 "adf7306666fad8b4af7099c5525aa7236157d82415e7fe6579cc30843d5cd110"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68d15b68e9ba43d3bfd30260a6b0f6e68191c224622967dfcfe8f189f0f2f69b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68d15b68e9ba43d3bfd30260a6b0f6e68191c224622967dfcfe8f189f0f2f69b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68d15b68e9ba43d3bfd30260a6b0f6e68191c224622967dfcfe8f189f0f2f69b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1411548ef4c6790792a69df6bf6f24f90cd73ba8984b63a360f5e7720f6afebc"
    sha256 cellar: :any_skip_relocation, ventura:       "1411548ef4c6790792a69df6bf6f24f90cd73ba8984b63a360f5e7720f6afebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68d15b68e9ba43d3bfd30260a6b0f6e68191c224622967dfcfe8f189f0f2f69b"
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
