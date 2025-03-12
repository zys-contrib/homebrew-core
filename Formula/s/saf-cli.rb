class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.4.20.tgz"
  sha256 "d705aa5e126f5c5893afa626ef9a532e5618ab7e63e04b433ec1ce7c93899c52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6144d26c414053dc74c93974c499a709344899a4a95d5dbb95dff5d9847cf88a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6144d26c414053dc74c93974c499a709344899a4a95d5dbb95dff5d9847cf88a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6144d26c414053dc74c93974c499a709344899a4a95d5dbb95dff5d9847cf88a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8af07ac28bd4bed17d61fbc2196faec7c0839d702632252c735433cabcc3fdcf"
    sha256 cellar: :any_skip_relocation, ventura:       "8af07ac28bd4bed17d61fbc2196faec7c0839d702632252c735433cabcc3fdcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32526d3b5e442c083cb4c7eb756c95192b36f7b2aed51b680756a6cbaa04036f"
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
