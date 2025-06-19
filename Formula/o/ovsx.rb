class Ovsx < Formula
  desc "Command-line interface for Eclipse Open VSX"
  homepage "https://www.npmjs.com/package/ovsx"
  url "https://registry.npmjs.org/ovsx/-/ovsx-0.10.4.tgz"
  sha256 "45a08bdd15d3ab8b91697831ae57ade1771c659420e10dc8c3357f3f04a3e35e"
  license "EPL-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    error = shell_output(bin/"ovsx verify-pat 2>&1", 1)
    assert_match "Unable to read the namespace's name", error
  end
end
