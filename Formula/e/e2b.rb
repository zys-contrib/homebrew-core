class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-1.5.1.tgz"
  sha256 "e9f2b9ba395da1fbc93bc3fa583fb52cc2447632001a47f8810bb16cb56099bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1e96e6842e345c5b5fdc323abfbb4cbebd5ef01366c5d2d95d2e31031c9bd3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1e96e6842e345c5b5fdc323abfbb4cbebd5ef01366c5d2d95d2e31031c9bd3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1e96e6842e345c5b5fdc323abfbb4cbebd5ef01366c5d2d95d2e31031c9bd3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ed2a8624dffca357ae8152b001f10713bd1428ecdc3e3f5ca7539d489465ad8"
    sha256 cellar: :any_skip_relocation, ventura:       "1ed2a8624dffca357ae8152b001f10713bd1428ecdc3e3f5ca7539d489465ad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1e96e6842e345c5b5fdc323abfbb4cbebd5ef01366c5d2d95d2e31031c9bd3b"
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
