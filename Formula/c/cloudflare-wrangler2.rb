class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.78.3.tgz"
  sha256 "dc70ad82a5abd558113130092efbcf0cca6c878e867d05efaeaf3f7f86475f5c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1710aa1999e438293bac5324f3155c4a32fa344a15c2b579a562b80633288a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1710aa1999e438293bac5324f3155c4a32fa344a15c2b579a562b80633288a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1710aa1999e438293bac5324f3155c4a32fa344a15c2b579a562b80633288a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6bfaa5ac65fcb1425190d9a14745041bd2da584398bfe91908696464f27aed4"
    sha256 cellar: :any_skip_relocation, ventura:       "c6bfaa5ac65fcb1425190d9a14745041bd2da584398bfe91908696464f27aed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c3666b5679347f279ecc7bb88abff72fc662eee3f84386304d834a82af74f2f"
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
