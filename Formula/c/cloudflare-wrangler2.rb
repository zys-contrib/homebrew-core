class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.78.10.tgz"
  sha256 "33365f834c0f7f1e7a8731187eca160e94c9dfd7fc538273f78eac334172d4ef"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab7aea6671ecc8147f921a549d7320a649e05c4bc93532ac13505cb30eb6a34e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab7aea6671ecc8147f921a549d7320a649e05c4bc93532ac13505cb30eb6a34e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab7aea6671ecc8147f921a549d7320a649e05c4bc93532ac13505cb30eb6a34e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6cbb1c25027cce24dc0aec5d99fdd3f8faf0671253c862e3fc377337b0cd0d9"
    sha256 cellar: :any_skip_relocation, ventura:       "c6cbb1c25027cce24dc0aec5d99fdd3f8faf0671253c862e3fc377337b0cd0d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7dd40878e63a69f27e2d99a84b66c6f762ee6ce677ba1bf92f5f9da057e9085"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
