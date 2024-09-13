class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.78.1.tgz"
  sha256 "c49c0f8c47b71306613e8ba6424b70a965d69d035c25c1c583805ec2b8ccbfba"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75a27522816704b412a379bfe586abb8ecf211590a571dd954d6ea72e0e5ad9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75a27522816704b412a379bfe586abb8ecf211590a571dd954d6ea72e0e5ad9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75a27522816704b412a379bfe586abb8ecf211590a571dd954d6ea72e0e5ad9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4a8ba00ebad82d5896c8ade85c39ded9fe3e49437861c7467c1a6bc12dee640"
    sha256 cellar: :any_skip_relocation, ventura:       "b4a8ba00ebad82d5896c8ade85c39ded9fe3e49437861c7467c1a6bc12dee640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b8beb8e38b1d3d8cdf52cb520d469af2c7acce1e096e2ea6170e8e42e8b0638"
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
