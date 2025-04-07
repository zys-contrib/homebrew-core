class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.8.0.tgz"
  sha256 "c0b15ed9ca392706e208551a38c635021dc3244b8287a4127d6a18436e0357be"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "34d7bfa106b78801d832f0117e42b76a12fd24c02b22c806696b1de5f232c996"
    sha256 cellar: :any,                 arm64_sonoma:  "34d7bfa106b78801d832f0117e42b76a12fd24c02b22c806696b1de5f232c996"
    sha256 cellar: :any,                 arm64_ventura: "34d7bfa106b78801d832f0117e42b76a12fd24c02b22c806696b1de5f232c996"
    sha256                               sonoma:        "52ce1dab73815a1ac2805739550c8bd39f7abedf50742362099218fda6df38de"
    sha256                               ventura:       "52ce1dab73815a1ac2805739550c8bd39f7abedf50742362099218fda6df38de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a608e1e0d97b0a18996d73b019b6492739795475231660eafdec01599770071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b27d8100f61c943138ffd20a3d2ec774093be0524edd6ea973bfe056d651b3f"
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
