class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.4.20.tgz"
  sha256 "d705aa5e126f5c5893afa626ef9a532e5618ab7e63e04b433ec1ce7c93899c52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b9704227909d9c5312052fbf165c2cabef79450627d2cbc246c54fb5cea2906"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b9704227909d9c5312052fbf165c2cabef79450627d2cbc246c54fb5cea2906"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b9704227909d9c5312052fbf165c2cabef79450627d2cbc246c54fb5cea2906"
    sha256 cellar: :any_skip_relocation, sonoma:        "29caaaeca6cc4cdc3f5dd55aa6b49ca2d076c7badd3d447104444a59431077e2"
    sha256 cellar: :any_skip_relocation, ventura:       "29caaaeca6cc4cdc3f5dd55aa6b49ca2d076c7badd3d447104444a59431077e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b9704227909d9c5312052fbf165c2cabef79450627d2cbc246c54fb5cea2906"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/saf --version")

    output = shell_output("#{bin}/saf scan")
    assert_match "Visit https://saf.mitre.org/#/validate to explore and run inspec profiles", output
  end
end
