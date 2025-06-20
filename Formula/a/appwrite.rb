class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-8.0.2.tgz"
  sha256 "a87f5ddb4b7119b1a40e272983be6f061f3d595ff0407f9cdfced0e2e8d9872d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fe27078b30500e6edb06198496cec4afb74727fa0744e23e61eada845bb645f2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Ensure uniform bottles
    inreplace [
      libexec/"lib/node_modules/appwrite-cli/install.sh",
      libexec/"lib/node_modules/appwrite-cli/ldid/Makefile",
      libexec/"lib/node_modules/appwrite-cli/node_modules/jake/Makefile",
    ], "/usr/local", HOMEBREW_PREFIX
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
