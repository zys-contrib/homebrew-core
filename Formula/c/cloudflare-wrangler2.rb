class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.103.0.tgz"
  sha256 "95400c445d3c5020d88043cd85335e5f3a175ad7481f16c1d1094a214e4fe04e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81f4b4dfce3dbd9637fd8f2b6037002646ca6cb82920ac0b4544d09d4adc7de1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81f4b4dfce3dbd9637fd8f2b6037002646ca6cb82920ac0b4544d09d4adc7de1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81f4b4dfce3dbd9637fd8f2b6037002646ca6cb82920ac0b4544d09d4adc7de1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bd1c6092cb152a9abd90a2f7fcae97d2856fdd924f4bae47a72b29504ead3ea"
    sha256 cellar: :any_skip_relocation, ventura:       "8bd1c6092cb152a9abd90a2f7fcae97d2856fdd924f4bae47a72b29504ead3ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e33d3d957079359f8b380445d7a95da7e09c97c5a3760ef3dcbc83ebf9358dbf"
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
