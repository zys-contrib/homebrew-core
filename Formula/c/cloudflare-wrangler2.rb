class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.78.3.tgz"
  sha256 "dc70ad82a5abd558113130092efbcf0cca6c878e867d05efaeaf3f7f86475f5c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca7bbbf281232c2d13bcf61ce44be60c2199c228b7a58061b7e090e2434a6e05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca7bbbf281232c2d13bcf61ce44be60c2199c228b7a58061b7e090e2434a6e05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca7bbbf281232c2d13bcf61ce44be60c2199c228b7a58061b7e090e2434a6e05"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9b7e529c0a3165fa1296d4bc5800abeccaec2f621945181412089f182a5a897"
    sha256 cellar: :any_skip_relocation, ventura:       "c9b7e529c0a3165fa1296d4bc5800abeccaec2f621945181412089f182a5a897"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4a83d15c62fd848c9ad13d054b02f640c803674e68a658da200d595a1b4e2bf"
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
