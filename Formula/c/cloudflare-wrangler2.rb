class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.72.1.tgz"
  sha256 "3df7e1bb2643c19fb53ed728cc1e64a10b63ca47321a148a414d41e7324e0cc6"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79ca81ad1dabb81644d85b3c285d716c4bf9629d4909fa52f645e5d688307f42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79ca81ad1dabb81644d85b3c285d716c4bf9629d4909fa52f645e5d688307f42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79ca81ad1dabb81644d85b3c285d716c4bf9629d4909fa52f645e5d688307f42"
    sha256 cellar: :any_skip_relocation, sonoma:         "c92db3c275b48b4b0b80e23d934970b6f410dd80b736f894b987fecad7f4ad88"
    sha256 cellar: :any_skip_relocation, ventura:        "c92db3c275b48b4b0b80e23d934970b6f410dd80b736f894b987fecad7f4ad88"
    sha256 cellar: :any_skip_relocation, monterey:       "c92db3c275b48b4b0b80e23d934970b6f410dd80b736f894b987fecad7f4ad88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af74158689550255942886754c1e0db8adcf0bcdf4dbda534a09f7c14d2315f2"
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
