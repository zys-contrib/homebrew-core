class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-1.5.0.tgz"
  sha256 "1f3583ffda264af21c5716d695a31b9d6b1cd0e0a284f8962cad7d6655cb2216"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fc0dda9220da411444b550e847f33d4f683981af6b448e0a85bd6aa8006efd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fc0dda9220da411444b550e847f33d4f683981af6b448e0a85bd6aa8006efd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6fc0dda9220da411444b550e847f33d4f683981af6b448e0a85bd6aa8006efd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cfa5154419378df125cadb524f20a932371cec4f491ad0d5f9c8a54a42b04a5"
    sha256 cellar: :any_skip_relocation, ventura:       "8cfa5154419378df125cadb524f20a932371cec4f491ad0d5f9c8a54a42b04a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fc0dda9220da411444b550e847f33d4f683981af6b448e0a85bd6aa8006efd9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/e2b --version")
    assert_match "Not logged in", shell_output("#{bin}/e2b auth info")
  end
end
