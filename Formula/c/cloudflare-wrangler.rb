class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.13.0.tgz"
  sha256 "0a6f12b158ba329f1f7129b5c1504eb76e9ff4adfdfd4aae253569352e9f8abd"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2dbfb1b0ff96e3628bf4a417fd16416bdad16d9a20c647a979e1a3b3c6d5aa70"
    sha256 cellar: :any,                 arm64_sonoma:  "2dbfb1b0ff96e3628bf4a417fd16416bdad16d9a20c647a979e1a3b3c6d5aa70"
    sha256 cellar: :any,                 arm64_ventura: "2dbfb1b0ff96e3628bf4a417fd16416bdad16d9a20c647a979e1a3b3c6d5aa70"
    sha256                               sonoma:        "05907a7526c825f314643a192ba97ba96bd41b15e11c343649851d5259ea13cb"
    sha256                               ventura:       "05907a7526c825f314643a192ba97ba96bd41b15e11c343649851d5259ea13cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "634bf9711d0c8b2856e43ca029279baef18d6f0e59c4efdea9cc3f69e0d8acd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b2f3b57e69958f8d07f98f934ca30b2abddab89591acecd5f8f0a7d7b9b79d6"
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
