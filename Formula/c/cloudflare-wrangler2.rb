class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.78.12.tgz"
  sha256 "67927d4057c69aa9293806b419c7c243a9cd16ad73f7af83d4cdd258e4a4ad81"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b64fc4f50b3cd04661e6052f0257da6b2380a878bf6e653911f810b83a49e27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b64fc4f50b3cd04661e6052f0257da6b2380a878bf6e653911f810b83a49e27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b64fc4f50b3cd04661e6052f0257da6b2380a878bf6e653911f810b83a49e27"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d582065ea9929f0888db448df05a506e3032cc22eecd2c36cde8a26d6e50a22"
    sha256 cellar: :any_skip_relocation, ventura:       "5d582065ea9929f0888db448df05a506e3032cc22eecd2c36cde8a26d6e50a22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7562c294ee64fba642105cf8968356868db899d7fb7e4513d2342f5d2511d91a"
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
