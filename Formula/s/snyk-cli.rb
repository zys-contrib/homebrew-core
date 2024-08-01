require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1292.2.tgz"
  sha256 "6d12f6451c0ac5e2e1263da6b9a6e6de6366e052fadaca2f82fd070ce7b6b534"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "769b32f4a0f145f44f3b0247625b2577d98990b311284df8f99f53537f289780"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "769b32f4a0f145f44f3b0247625b2577d98990b311284df8f99f53537f289780"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "769b32f4a0f145f44f3b0247625b2577d98990b311284df8f99f53537f289780"
    sha256 cellar: :any_skip_relocation, sonoma:         "75182e753e92601baadcfb7ef55a9a2bd4416875f6d6c8796dc34bf6ae73ac02"
    sha256 cellar: :any_skip_relocation, ventura:        "75182e753e92601baadcfb7ef55a9a2bd4416875f6d6c8796dc34bf6ae73ac02"
    sha256 cellar: :any_skip_relocation, monterey:       "75182e753e92601baadcfb7ef55a9a2bd4416875f6d6c8796dc34bf6ae73ac02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a01680df80e6c9c7ab4916b9f48f5bb0c8ee000c7bf04517794891e55af34b7"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end
