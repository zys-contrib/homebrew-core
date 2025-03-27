class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1296.1.tgz"
  sha256 "35d53f3a468df2a6c491b09b22195ea1082a00ac7a9f89f748e30d283479eb81"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71071814d115222f0986abaa0595c13244a3ce67cb29f681e5781e6eaa1cd705"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71071814d115222f0986abaa0595c13244a3ce67cb29f681e5781e6eaa1cd705"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71071814d115222f0986abaa0595c13244a3ce67cb29f681e5781e6eaa1cd705"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d6fb447fdfcce41fb2e20e2266fe5e8953e5a0ae73d7063e3c7446784233218"
    sha256 cellar: :any_skip_relocation, ventura:       "0d6fb447fdfcce41fb2e20e2266fe5e8953e5a0ae73d7063e3c7446784233218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a94ea88e97cf3d2a55c2e5771098546129a0605d578f8aa7c59bc4f1e9c05495"
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
