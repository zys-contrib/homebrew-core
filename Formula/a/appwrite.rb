class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-8.1.0.tgz"
  sha256 "4bb97995b58e7a0cd7756fbe4dbdfe82527518d832e4163d0d2e5b3eb5bb044d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0f5433ea9dce4a23a1a6aea59f062b6f3e12736ad6cbaa943f0d44fa6612c60a"
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
