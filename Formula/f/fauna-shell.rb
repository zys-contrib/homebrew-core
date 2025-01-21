class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-4.0.0.tgz"
  sha256 "6dd5c853c1a62e72d6101741a498b3b9fe4db21e68ec2e024541b488b858c77f"
  license "MPL-2.0"
  head "https://github.com/fauna/fauna-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f61c240a86f5c598cb335a81b0f9c4f1808c04e89a0a6159f837e61e60610a5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f61c240a86f5c598cb335a81b0f9c4f1808c04e89a0a6159f837e61e60610a5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f61c240a86f5c598cb335a81b0f9c4f1808c04e89a0a6159f837e61e60610a5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0738790ea782077df1050168e258e91a85cdb5c1c61aa540bad7f579f43026e6"
    sha256 cellar: :any_skip_relocation, ventura:       "0738790ea782077df1050168e258e91a85cdb5c1c61aa540bad7f579f43026e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f61c240a86f5c598cb335a81b0f9c4f1808c04e89a0a6159f837e61e60610a5d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    libexec.glob("lib/node_modules/fauna-shell/dist/{*.node,fauna}")
           .each { |f| rm(f) }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fauna --version")

    output = shell_output("#{bin}/fauna database list 2>&1", 1)
    assert_match "The requested user 'default' is not signed in or has expired.", output

    output = shell_output("#{bin}/fauna local --name local-fauna 2>&1", 1)
    assert_match "[StartContainer] Docker service is not available", output
  end
end
