class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1295.4.tgz"
  sha256 "2bce4c9466ef4db00bd8a99b4e6cbcf4b623cd359c62e0b74ad9c6c011d5e672"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e012f30e2ec4adf90d87cc306893787eee8490b45ffbca582ddc4dbd843780ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e012f30e2ec4adf90d87cc306893787eee8490b45ffbca582ddc4dbd843780ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e012f30e2ec4adf90d87cc306893787eee8490b45ffbca582ddc4dbd843780ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c82f8552c28963d666e20377cdd71ee1c7cb808cfe6bbb7a3ad96999e265293"
    sha256 cellar: :any_skip_relocation, ventura:       "2c82f8552c28963d666e20377cdd71ee1c7cb808cfe6bbb7a3ad96999e265293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1e2a4b517da27e76f713de32e1392aeee5107d02c3a873c8e47fc3a4272516c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "authentication failed (timeout)", output
  end
end
